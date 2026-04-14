module shift_register (
    input clk,
    input reset,
    input shift_dir, // 0 for left, 1 for right
    input [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else begin
            if (shift_dir == 1'b0) begin // left shift
                data_out <= {data_out[6:0], data_in[0]};
            end else begin // right shift
                data_out <= {data_in[7], data_out[7:1]};
            end
        end
    end
endmodule