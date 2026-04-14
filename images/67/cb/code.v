module top_module(
    input clk,
    input [3:0] a,
    input [3:0] b,
    input c,
    output reg [2:0] encoded_output
);// 4-bit comparator
    wire equal;
    assign equal = (a == b);

    // 3:4 decoder
    wire [3:0] decoder_input;
    assign decoder_input = {c, b, a};

    reg [3:0] decoder_output;
    always @(decoder_input) begin
        case(decoder_input)
            4'b0000: decoder_output = 4'b0001;
            4'b0001: decoder_output = 4'b0010;
            4'b0010: decoder_output = 4'b0100;
            4'b0011: decoder_output = 4'b1000;
            4'b0100: decoder_output = 4'b0001;
            4'b0101: decoder_output = 4'b0010;
            4'b0110: decoder_output = 4'b0100;
            4'b0111: decoder_output = 4'b1000;
            4'b1000: decoder_output = 4'b0001;
            4'b1001: decoder_output = 4'b0010;
            4'b1010: decoder_output = 4'b0100;
            4'b1011: decoder_output = 4'b1000;
            4'b1100: decoder_output = 4'b0001;
            4'b1101: decoder_output = 4'b0010;
            4'b1110: decoder_output = 4'b0100;
            4'b1111: decoder_output = 4'b1000;
        endcase
    end

    // Priority encoder
    always @(posedge clk) begin
        if (equal) begin
            case(a)
                4'b0001: encoded_output = 3'b000;
                4'b0010: encoded_output = 3'b001;
                4'b0100: encoded_output = 3'b010;
                4'b1000: encoded_output = 3'b011;
                default: encoded_output = 3'b000;
            endcase
        end else begin
            case(decoder_output)
                4'b0001: encoded_output = 3'b000;
                4'b0010: encoded_output = 3'b001;
                4'b0100: encoded_output = 3'b010;
                4'b1000: encoded_output = 3'b011;
                default: encoded_output = 3'b000;
            endcase
        end
    end

endmodule