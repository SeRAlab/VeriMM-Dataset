module top_module(input clk, input [7:0] divFactor, output reg divClk);reg [31:0] count = 0;
    reg [31:0] div = 0;
    reg [31:0] divFactorReg = 0;
    
    always @(posedge clk) begin
        count <= count + 1;
        if (divFactor != divFactorReg) begin
            divFactorReg <= divFactor;
            div <= (1 << divFactorReg) - 1;
        end
        if (count >= div) begin
            divClk <= ~divClk;
            count <= 0;
        end
    end
endmodule