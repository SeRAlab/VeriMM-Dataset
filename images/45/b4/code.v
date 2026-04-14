module top_module(
    input wire [31:0] a, b,
    output reg [31:0] q,
    input wire [2:0] mode
);reg [63:0] fullq;

    always @(*) begin
        case (mode)
            3'b000: begin
                fullq = $signed(a) * $signed(b);
                q = fullq[31:0];
            end 
            3'b001: begin
                fullq = $signed(a) * $signed(b);
                q = fullq[63:32];
            end
            3'b010: begin
                fullq = $signed(a) * $signed({1'b0, b});
                q = fullq[63:32];
            end
            3'b011: begin
                fullq = a * b;
                q = fullq[63:32];
            end
            3'b100: begin
                q <= $signed(a) / $signed(b);
            end
            3'b101: begin
                q <= a / b;
            end
            3'b110: begin 
                q <= $signed(a) % $signed(b);
            end
            3'b111: begin
                q <= a % b;
            end
        endcase
    end
    
endmodule