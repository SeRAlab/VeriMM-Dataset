module shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0; // Reset the register to 0
        end else if (load) begin
            data_out <= data_in; // Load new data
        end else begin
            data_out <= {data_out[14:0], 1'b0}; // Shift left
        end
    end
endmodule