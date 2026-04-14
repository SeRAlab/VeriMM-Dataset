module top_module(
    input clk,
    input parallel_load,
    input serial_in,
    output serial_out,
    input [3:0] data_in
);reg [3:0] register;

    always @(posedge clk) begin
        if (parallel_load) begin
            register <= data_in;
        end else begin
            register <= {register[2:0], serial_in};
        end
    end

    assign serial_out = register[0];

endmodule