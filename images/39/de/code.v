module shift_register (
    input wire clk,
    input wire rst,
    input wire ld,
    input wire sl,
    input wire sr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0;
        end else if (ld) begin
            data_out <= data_in;
        end else if (sl) begin
            data_out <= {data_out[14:0], 1'b0}; // Shift left
        end else if (sr) begin
            data_out <= {1'b0, data_out[15:1]}; // Shift right
        end
    end
endmodule