module even_parity_generator (  
    input [3:0] data_in,  
    output reg parity_out  
);  
    always @(*) begin  
        parity_out = ~(data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3]);  
    end  
endmodule