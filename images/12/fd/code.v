module pipo_shift_register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire shift,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0; // Reset the register
    end else if (load) begin
        data_out <= data_in; // Load new data into the register
    end else if (shift) begin
        data_out <= {1'b0, data_out[7:1]}; // Shift right
    end
end

endmodule