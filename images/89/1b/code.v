module top_module(
    input clk,
    input reset,
    input [3:0] input_binary,
    output reg [6:0] output_segments
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        output_segments <= 7'b0000001;
    end else begin
        case(input_binary)
            4'd0: output_segments <= 7'b0111111;
            4'd1: output_segments <= 7'b0000110;
            4'd2: output_segments <= 7'b1011011;
            4'd3: output_segments <= 7'b1001111;
            4'd4: output_segments <= 7'b1100110;
            4'd5: output_segments <= 7'b1101101;
            4'd6: output_segments <= 7'b1111101;
            4'd7: output_segments <= 7'b0000111;
            4'd8: output_segments <= 7'b1111111;
            4'd9: output_segments <= 7'b1101111;
            default: output_segments <= 7'b1111110;
        endcase
    end
end

endmodule