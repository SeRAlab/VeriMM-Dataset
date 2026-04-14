module des_round(input [31:0] data_in,  
                  input [31:0] key,  
                  output reg [31:0] data_out);  
  
    always @(*) begin  
        data_out = data_in ^ key;  
    end  
endmodule