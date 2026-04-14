module top_module(
    input clk,
    input reset,   // Synchronous active high reset
    input load,    // Synchronous load
    input [3:0] data_in,
    output reg [3:0] count
);reg [3:0] count_reg1;
reg [3:0] count_reg2;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 4'b0000;
        count_reg2 <= 4'b0000;
    end
    else if (load) begin
        count_reg1 <= data_in;
        count_reg2 <= count_reg1;
    end
    else begin
        count_reg1 <= count_reg2 + 4'b0001;
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2;

endmodule