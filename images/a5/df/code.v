module top_module(
    input clk,
    input load,
    input shift_dir,
    input [7:0] parallel_in,
    input serial_in,
    output [7:0] serial_out
);reg [7:0] data;

always @(posedge clk) begin
    if (load) begin
        data <= parallel_in;
    end else begin
        if (shift_dir) begin
            data <= {serial_in, data[7:1]};
        end else begin
            data <= {data[6:0], serial_in};
        end
    end
end

assign serial_out = data;

endmodule