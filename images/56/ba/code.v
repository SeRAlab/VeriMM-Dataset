module top_module(
    input clk,
    input [3:0] parallel_in,
    input serial_in,
    output serial_out
);reg [3:0] register;

always @(posedge clk) begin
    if (parallel_in) begin
        register <= parallel_in;
    end else begin
        register <= {register[2:0], serial_in};
    end
end

assign serial_out = register[0];

endmodule