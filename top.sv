module vsync (
    input  logic clk_25mhz,
    input  logic reset,
    input  logic h_end,
    output logic vsync,
    output logic [9:0] v_count
);

    // the full cycle (to 525)
    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;
    
    always_ff @(posedge clk_25mhz or posedge reset) begin
        if (reset || v_count == V_TOTAL - 1)
            v_count <= 0;
        else
            v_count <= v_count + 1;
    end
    
    // same as hsync
    // more than visible and front, but also less than visible, front and sync
    assign vsync = ~(v_count >= (V_VISIBLE + V_FRONT) && v_count < (V_VISIBLE + V_FRONT + V_SYNC));


endmodule
