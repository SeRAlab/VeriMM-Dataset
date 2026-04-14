module mux4to1 (
    input wire [3:0] I,  // 4-bit input
    input wire [1:0] S,  // 2-bit select
    output wire Y        // output
);
    assign Y = (S == 2'b00) ? I[0] :
               (S == 2'b01) ? I[1] :
               (S == 2'b10) ? I[2] :
               (S == 2'b11) ? I[3] : 1'b0; // Default case (though should never happen)
endmodule