module top_module(
    input wire [9:0] datain,
    input wire clk,
    input wire reset,
    output reg [9:0] dataout,
    output reg validout
);always @(posedge clk) begin
    if (reset == 1'b1) begin
        dataout <= 0;
        validout <= 0;
    end else begin
        if (datain >= 10'd100) begin
            dataout <= datain;
            validout <= 1;
        end else begin
            dataout <= 0;
            validout <= 0;
        end
    end
end

endmodule