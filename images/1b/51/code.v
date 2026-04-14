module mux4to1 (
    input wire [3:0] I,  // 4 input lines
    input wire [1:0] S,  // 2 select lines
    output wire Y        // output line
);
    assign Y = (S == 2'b00) ? I[0] :
               (S == 2'b01) ? I[1] :
               (S == 2'b10) ? I[2] :
               (S == 2'b11) ? I[3] : 1'b0;
endmodule