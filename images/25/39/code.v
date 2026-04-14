module shift_register (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    input wire shift_dir, // 0 for left shift, 1 for right shift
    output reg [15:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
        end else begin
            if (shift_dir == 0) begin
                // Left shift
                data_out <= {data_out[14:0], 1'b0}; // Shift left and fill with 0
            end else begin
                // Right shift
                data_out <= {1'b0, data_out[15:1]}; // Shift right and fill with 0
            end
        end
    end
endmodule