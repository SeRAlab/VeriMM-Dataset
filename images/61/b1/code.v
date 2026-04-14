module top_module(
    input clk,
    input load,
    input [3:0] data_in,
    input shift_in,
    output [3:0] data_out,
    output shift_out
);reg [3:0] register;

always @(posedge clk) begin
    if (load) begin
        register <= data_in;
    end else begin
        register <= {shift_in, register[3:1]};
    end
end

assign data_out = register;
assign shift_out = register[3];

endmodule