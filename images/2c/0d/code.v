module rnn_cell (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] input_vector,
    input wire [3:0] prev_state,
    output reg [3:0] output_vector,
    output reg [3:0] current_state
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_vector <= 4'b0000;
            current_state <= 4'b0000;
        end else if (enable) begin
            {output_vector, current_state} <= prev_state + input_vector;
            if (current_state > 4'b1111) begin
                current_state <= ~current_state + 1; // 2's complement
            end
        end
    end
endmodule