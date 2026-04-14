module shift_register(
    input clk,
    input rst,
    input shift_lr, // 0 for left shift, 1 for right shift
    output reg [1:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 2'b00; // reset output to 0
        end else begin
            if (shift_lr) begin
                // Right shift
                data_out <= {1'b0, data_out[1]};
            end else begin
                // Left shift
                data_out <= {data_out[0], 1'b0};
            end
        end
    end
endmodule