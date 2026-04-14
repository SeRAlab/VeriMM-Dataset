module top_module(
    input [3:0] in,
    output [2:0] out
);reg [2:0] count;
reg prev;

always @(in) begin
    if (in == 4'b0000) begin
        count <= 3'b000;
        prev <= 1'b0;
    end
    else if (in == 4'b1111) begin
        count <= 3'b111;
        prev <= 1'b1;
    end
    else if (in[3] & in[2] & in[1] & in[0]) begin
        count <= 3'b100;
        prev <= 1'b1;
    end
    else if (in[3] & in[2] & in[1] & ~in[0] & prev) begin
        count <= 3'b011;
        prev <= 1'b1;
    end
    else if (in[3] & in[2] & ~in[1] & prev) begin
        count <= 3'b010;
        prev <= 1'b1;
    end
    else if (in[3] & ~in[2] & prev) begin
        count <= 3'b001;
        prev <= 1'b1;
    end
    else begin
        count <= 3'b000;
        prev <= 1'b0;
    end
end

assign out = count;

endmodule