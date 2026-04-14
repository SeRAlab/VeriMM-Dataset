module top_module(
    input clk,
    input data_in,
    input shift_left,
    input load,
    output reg [2:0] data_out
);reg [2:0] reg1, reg2, reg3;

always @(posedge clk) begin
    if (load) begin
        reg1 <= data_in;
        reg2 <= reg1;
        reg3 <= reg2;
    end else if (shift_left) begin
        reg1 <= reg2;
        reg2 <= reg3;
        reg3 <= reg3;
    end
end

assign data_out = reg1;

endmodule