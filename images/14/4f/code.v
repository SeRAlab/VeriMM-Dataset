module shift_register (
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 4'b0000; // Clear the register
    end else if (load) begin
        data_out <= data_in; // Load the input data
    end else begin
        data_out <= {data_out[2:0], 1'b0}; // Shift left
    end
end

endmodule