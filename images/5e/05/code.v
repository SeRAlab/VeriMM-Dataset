module top_module(
data_in    , 
parity_out   
);output  parity_out ;
input [7:0] data_in ; 
     
wire parity_out ; 

function parity;
  input [31:0] data; 
  begin
    parity =  (data_in[0] ^ data_in[1]) ^  
              (data_in[2] ^ data_in[3]) ^ 
              (data_in[4] ^ data_in[5]) ^  
              (data_in[6] ^ data_in[7]);
  end 
endfunction 
 
      
assign parity_out = parity(data_in);

endmodule