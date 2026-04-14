module rnn_cell (
    input [1:0] input_data,
    input [1:0] prev_h,
    output reg [1:0] next_h
);
    
    always @(*) begin
        next_h = (input_data + prev_h) % 4;
    end

endmodule