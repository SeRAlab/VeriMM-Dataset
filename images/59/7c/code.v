module top_module(
		input	wire	[13:0]	addr_i,
		output	wire		pre_dec_o,
		output	wire		pre_dec_err_o
	);parameter N_DOMAINS = 2;



	

	
	
	
	
	
	


	

	
	
	


             
    
    reg pre_dec;
    reg pre_dec_err;
    assign pre_dec_o = pre_dec;
    assign pre_dec_err_o = pre_dec_err;

    always @(addr_i) begin
        pre_dec     = 0;
        pre_dec_err = 0;
        case (addr_i[5:2])
            
            'h0, 'h8, 'ha: pre_dec = 0;
            
            'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7: pre_dec = 1;
            default: begin 
                pre_dec     = 0;
                pre_dec_err = 1;
            end
        endcase
    end

	
	
	


endmodule