module top_module( input write_address_pass , input write_data_pass,
output reg [31:0] instruction_count , input clk, input reset

    );always@(posedge clk) begin 
    if(reset) begin 
    instruction_count <= 0 ;
    end
    
    else if(write_address_pass && write_data_pass) begin 
    instruction_count <= instruction_count +1 ; 
    end
    
    end
    
    
endmodule