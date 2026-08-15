module vga_top (
    input  logic clk_100mhz,
    input  logic reset,
    output logic hsync,
    output logic vsync,
    output logic [3:0] vga_red,
    output logic [3:0] vga_green,
    output logic [3:0] vga_blue
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
    
    assign vga_red   = video_on ? 4'h0 : 4'h0;
    assign vga_green = video_on ? 4'h0 : 4'h0;
    assign vga_blue  = video_on ? 4'hF : 4'h0;
    
    



endmodule