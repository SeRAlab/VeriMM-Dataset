module binary_decoder(
    input [1:0] bin,
    output [3:0] dout
);
    
    assign dout = (bin == 2'b00) ? 4'b0001 :
                  (bin == 2'b01) ? 4'b0010 :
                  (bin == 2'b10) ? 4'b0100 :
                  (bin == 2'b11) ? 4'b1000 : 4'b0000;
    
endmodule