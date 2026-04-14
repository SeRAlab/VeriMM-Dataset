module checksum_calculator(
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [2:0] checksum_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            checksum_out <= 3'b000; // Reset the checksum
        end else begin
            checksum_out <= data_in[0] + data_in[1] + data_in[2] + data_in[3]; // Calculate checksum
        end
    end
endmodule