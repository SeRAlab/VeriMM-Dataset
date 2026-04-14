module top_module(clk, parallel_load, serial_in, serial_out, register_out);parameter WIDTH = 8;

input clk;
input parallel_load;
input serial_in;
output serial_out;
output [WIDTH-1:0] register_out;

reg [WIDTH-1:0] shift_register;

always @(posedge clk) begin
    if (parallel_load) begin
        shift_register <= serial_in;
    end else begin
        shift_register <= {shift_register[WIDTH-2:0], serial_in};
    end
end

assign serial_out = shift_register[0];
assign register_out = shift_register;

endmodule