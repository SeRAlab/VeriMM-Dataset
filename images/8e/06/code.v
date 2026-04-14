module top_module(
    input clk,
    input load,
    input shift_left,
    input shift_right,
    input reset,
    input [3:0] data_in,
    output [3:0] data_out
);reg [3:0] register;

always @(posedge clk) begin
    if (reset) begin
        register <= 4'b0;
    end else if (load) begin
        register <= data_in;
    end else if (shift_left) begin
        register <= {register[2:0], 1'b0};
    end else if (shift_right) begin
        register <= {1'b0, register[3:1]};
    end
end

assign data_out = register;

endmodule