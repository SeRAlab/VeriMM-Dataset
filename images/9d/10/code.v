module top_module(
    CLOCK_50,
    CLOCK_25
);input CLOCK_50;
    output CLOCK_25;
    reg clk = 0;

    always @(posedge CLOCK_50) begin
        clk <= ~clk;
    end
 
    assign CLOCK_25 = clk;
endmodule