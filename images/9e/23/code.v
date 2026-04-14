module top_module(
    input clk,
    input [7:0] in,
    output [7:0] rising_edge,
    output reg [2:0] pos
);// Rising edge detector
    reg [7:0] prev_in;
    reg [7:0] count;
    reg [7:0] diff;
    always @(posedge clk) begin
        prev_in <= in;
        diff <= in ^ prev_in;
        if (diff != 0) begin
            count <= 8'b00000001;
        end else begin
            count <= count + 1;
        end
    end
    assign rising_edge = diff & (count == 8'b00000001);

    // Priority encoder
    reg [3:0] gray;
    always @* begin
        gray = {in[7], in[7]^in[6], in[6]^in[5], in[5]^in[4], in[4]^in[3], in[3]^in[2], in[2]^in[1], in[1]^in[0]};
    end
    always @* begin
        case (gray)
            4'b0000: pos = 3'b000;
            4'b0001: pos = 3'b001;
            4'b0011: pos = 3'b010;
            4'b0111: pos = 3'b011;
            4'b1111: pos = 3'b100;
            default: pos = 3'b000;
        endcase
    end

endmodule