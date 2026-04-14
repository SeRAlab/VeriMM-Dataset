module checksum_calculator(
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    output reg [4:0] checksum_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum_out <= 5'b00000; // Reset checksum to 0
        end else begin
            checksum_out <= checksum_out ^ data_in; // Calculate checksum
        end
    end
endmodule