module reset_controller(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b00000000; // Default value on reset
        end else begin
            data_out <= data_in; // Follow input when not in reset
        end
    end
endmodule