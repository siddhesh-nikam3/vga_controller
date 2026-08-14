module hsync (
    input logic clk_25mhz,
    input logic reset,
    output logic hsync,
    output logic [9:0] h_count   // tells top module current pixel column from 0 to 799
);
    // the full cycle (adds up to 800)
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;
    
    
    always_ff @(posedge clk_25mhz or posedge reset) begin
        if (reset || (h_count == H_TOTAL - 1))
            h_count <= 0;
        else
            h_count <= h_count + 1;
    end
    
   // checks if hsync is between 656 and 751
   // Is h_count more than visible and front
   // Is h_count less than visible, front, and sync
   assign hsync = ~(h_count >= (H_VISIBLE + H_FRONT) && h_count <  (H_VISIBLE + H_FRONT + H_SYNC));





endmodule