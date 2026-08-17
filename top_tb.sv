module vga_top_tb;

    logic clk_100mhz;
    logic reset;
    logic hsync, vsync;
    logic [3:0] vga_red, vga_green, vga_blue;

    // instantiate the design under test
    vga_top uut (
        .clk_100mhz(clk_100mhz),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );
    
    // generate 100 mhz clock
    initial clk_100mhz = 0;
    always #5 clk_100mhz = ~clk_100mhz; // toggles every 5ns
    
    // stimulus
        initial begin
        reset = 1;
        #20;
        reset = 0;

        #2000000;  // 2ms

        $finish;
    end
    




endmodule
