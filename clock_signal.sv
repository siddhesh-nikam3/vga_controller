module clock_signal(
    
    input  logic clk_100mhz, // onboard clock
    input  logic reset,
    output logic clk_25mhz // vga pixel clock at 50% duty cycle
    
);

    logic [1:0] counter; // 00 01 10 11 (2nd digit)
    
    always_ff @(posedge clk_100mhz or posedge reset) begin
        if (reset)
            counter <= 2'b0;
        else
            counter <= counter + 1;
    end
    
    assign clk_25mhz = counter[1]; // second digit of the counter
    
endmodule