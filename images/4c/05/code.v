module shift_register(
    input clk,
    input reset,
    input enable,
    input load,
    input [31:0] parallel_in,
    input serial_in,
    
    output reg [31:0] parallel_out
);

always @(posedge clk) begin
    if (reset) begin
        parallel_out <= 32'b0;
    end else if (load) begin
        parallel_out <= parallel_in;
    end else if (enable) begin
        parallel_out <= {parallel_out[30:0], serial_in};
    end
end

endmodule