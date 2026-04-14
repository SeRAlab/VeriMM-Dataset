module top_module(
    input clk,
    input reset,
    input [3:0] hex_input,
    output [6:0] segment_output
    );reg [6:0] segment_val;
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            segment_val <= 7'b1000000;
        end else begin
            case (hex_input)
                4'h0: segment_val <= 7'b1000000;
                4'h1: segment_val <= 7'b1111001;
                4'h2: segment_val <= 7'b0100100;
                4'h3: segment_val <= 7'b0110000;
                4'h4: segment_val <= 7'b0011001;
                4'h5: segment_val <= 7'b0010010;
                4'h6: segment_val <= 7'b0000010;
                4'h7: segment_val <= 7'b1111000;
                4'h8: segment_val <= 7'b0000000;
                4'h9: segment_val <= 7'b0011000;
                4'ha: segment_val <= 7'b0001000;
                4'hb: segment_val <= 7'b0000011;
                4'hc: segment_val <= 7'b1000110;
                4'hd: segment_val <= 7'b0100001;
                4'he: segment_val <= 7'b0000110;
                4'hf: segment_val <= 7'b0001110;
                default: segment_val <= 7'b1000000;
            endcase
        end
    end

    assign segment_output = segment_val;

endmodule