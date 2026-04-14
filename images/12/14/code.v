module shift_register (
    input clk,
    input rst,
    input [1:0] data_in,
    input shift_dir, // 0 for left shift, 1 for right shift
    output reg [1:0] q_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_out <= 2'b00;
        end else begin
            if (shift_dir == 0) begin
                q_out <= {q_out[0], data_in[1]}; // left shift
            end else begin
                q_out <= {data_in[0], q_out[1]}; // right shift
            end
        end
    end
endmodule