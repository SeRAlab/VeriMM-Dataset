module parallel_load_register
(
    input clk,
    input reset,
    input load,
    input [11:0] data_in,
    output reg [11:0] data_out
);

    always @(posedge clk) begin
        if (reset) begin
            data_out <= 12'b000000000000; // Reset register to 000000000000
        end else if (load) begin
            data_out <= data_in; // Load input data
        end
    end

endmodule