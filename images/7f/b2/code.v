module top_module(parity_out, data_in);parameter WIDTH = 8 ;
parameter NUM = 16 ;

input	[WIDTH * NUM - 1 : 0]	data_in ; 

output	[NUM - 1 : 0]		parity_out ; 
reg	[NUM - 1 : 0]		parity ; 

integer i ;
integer j ;

always @(data_in)
    for (i = 0; i <= NUM - 1 ; i = i + 1) begin
	    parity[i] = 1'b0 ;
        for (j = WIDTH * i; j <= WIDTH * (i + 1) - 1 ; j = j + 1) begin
            parity[i] = parity[i] ^ data_in[j] ;
        end
    end

assign parity_out[NUM - 1 : 0] = parity[NUM - 1 : 0];

endmodule