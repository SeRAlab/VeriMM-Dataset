module top_module(
    input clk,  
    input reset,
    input [4:0] data_in,
    input [4:0] L,
    input K,
    input COMPLS6,
    output [5:0] data_out
    );wire A, B, C, D, E;
    assign {E, D, C, B, A} = data_in;
    wire L40, L31, L22, L13, L04;
    assign {L40, L31, L22, L13, L04} = L;
    reg a, b, c, d, e, i;
    
    always @(posedge clk)
    begin    
        if (reset) begin
            a <= 0;
            b <= 0;
            c <= 0;
            d <= 0;
            e <= 0;
            i <= 0;
        end else begin
            a <= A ^ COMPLS6; 
            b <= ((~L40 & B) | L04) ^ COMPLS6;
            c <= (L04 | C) ^ (L13 & D & E) ^ COMPLS6; 
            d <= (D & ~L40) ^ COMPLS6;
            e <= (~(L13 & D & E) & E) ^ (~E & L13) ^ COMPLS6; 
            i <= (~E & L22) ^ (L22 & K) ^ (L04 & E) ^ (E & L40) ^ (E & L13 & ~D) ^ COMPLS6;
        end
    end
    assign data_out = {a, b, c, d, e, i};
    
endmodule