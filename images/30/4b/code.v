module rnn_cell (
    input clk,
    input reset,
    input [1:0] input_data,
    output reg [1:0] output_data
);
    
    reg [1:0] previous_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_data <= 2'b00;
            previous_output <= 2'b00;
        end else begin
            previous_output <= output_data;
            output_data <= (input_data + previous_output > 2'b11) ? 2'b11 : (input_data + previous_output);
        end
    end
endmodule