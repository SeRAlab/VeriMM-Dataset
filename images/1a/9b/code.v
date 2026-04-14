module shift_register (
    input clk,
    input load,
    input shift,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk) begin
    if (load) begin
        data_out <= data_in;  // Load data on load signal
    end else if (shift) begin
        data_out <= {1'b0, data_out[7:1]};  // Shift right
    end
end

endmodule