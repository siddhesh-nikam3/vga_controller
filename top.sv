module vga_top (
    input  logic clk_100mhz,
    input  logic reset,
    input  logic btnU, btnD, btnL, btnR, btnC,
    output logic hsync, vsync,
    output logic [3:0] vga_red, vga_green, vga_blue
);

    logic clk_25mhz;
    logic [9:0] h_count, v_count;
    logic h_end;
    logic video_on;
    
    // pixel clock
    clock_signal clk_gen (
        .clk_100mhz(clk_100mhz),
        .reset(reset),
        .clk_25mhz(clk_25mhz)
    );
    
    // horizontal sync
   hsync hsync_gen (
        .clk_25mhz(clk_25mhz),
        .reset(reset),
        .hsync(hsync),
        .h_count(h_count)
    );
    
    assign h_end = (h_count == 799); // fires a 1 once it ends
    
        // 3) vertical sync + line counter
    vsync vsync_gen (
        .clk_25mhz(clk_25mhz),
        .reset(reset),
        .h_end(h_end),
        .vsync(vsync),
        .v_count(v_count)
    );
    
    // checks if video is on
    assign video_on = (h_count < 640) && (v_count < 480);
    
    // Button Sync
    logic btnU_s, btnD_s, btnL_s, btnR_s, btnC_s;
    always_ff @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            btnU_s <= 0;
            btnD_s <= 0;
            btnL_s <= 0;
            btnR_s <= 0;
            btnC_s <= 0;
        end else begin
            btnU_s <= btnU;
            btnD_s <= btnD; 
            btnL_s <= btnL;
            btnR_s <= btnR;
            btnC_s <= btnC;
        end    
    end
    
    // frame tick
    logic [9:0] v_count_prev;
    logic frame_tick;
    always_ff @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            v_count_prev <= 0;
            frame_tick   <= 0;
        end else begin
            v_count_prev <= v_count;
            frame_tick   <= (v_count_prev != 0) && (v_count == 0);
        end
    end
    
    // square sprite
    localparam SQ_SIZE = 20;
    localparam SPEED = 4;
    localparam CENTER_X = 320 - SQ_SIZE/2;
    localparam CENTER_Y = 240 - SQ_SIZE/2;
    
    logic [9:0] sq_x, sq_y;
    
    always_ff @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            sq_x <= CENTER_X;
            sq_y <= CENTER_Y;
        end else if (frame_tick) begin
            if (btnC_s) begin
                sq_x <= CENTER_X;
                sq_y <= CENTER_Y;
            end else begin
                if (btnU_s && sq_y > SPEED) // going up
                    sq_y <= sq_y - SPEED;
                if (btnD_s && sq_y < 480 - SQ_SIZE - SPEED) // going down
                    sq_y <= sq_y + SPEED;
                if (btnL_s && sq_x > SPEED) // going left
                    sq_x <= sq_x - SPEED;
                if (btnR_s && sq_x < 640 - SQ_SIZE - SPEED) // going right
                    sq_x <= sq_x + SPEED;
            end
        end
    end
    
    // pixel in square detection
    logic in_square;
    assign in_square = (h_count >= sq_x) && // more than the start (horizontal)
                       (h_count < sq_x + SQ_SIZE) && // less than the end (horizontal)
                       (v_count >= sq_y) && // more than the start (vertical)
                       (v_count < sq_y + SQ_SIZE); // less than the end (vertical)
    
    // decides final color    
    always_comb begin
        if (!video_on) begin
            vga_red = 4'h0; vga_green = 4'h0; vga_blue = 4'h0;
        end else if (in_square) begin
            vga_red = 4'h0; vga_green = 4'h0; vga_blue = 4'h0; // black square
        end else begin
            vga_red = 4'h0; vga_green = 4'h0; vga_blue = 4'hF; // blue background
        end
    end



endmodule
