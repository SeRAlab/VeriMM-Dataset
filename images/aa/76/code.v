module top_module(
    x,
    S,
    Y
);input x;
input [1:0] S;
output [3:0] Y;
reg [3:0] Y;




always @(x, S) begin: DEMUX1_4_BV_LOGIC
    case (S)
        'h0: begin
            Y = {3'h0, x};
            
        end
        'h1: begin
            Y = {2'h0, x, 1'h0};
            
        end
        'h2: begin
            Y = {1'h0, x, 2'h0};
            
        end
        default: begin
            Y = {x, 3'h0};
            
        end
    endcase
end

endmodule