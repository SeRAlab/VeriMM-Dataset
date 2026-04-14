module top_module(
       output reg [31:0] read_data,
       input [3:0] address,     
       input [31:0] write_data,  
       input  Memwrite,         
       input  clock
    );reg [31:0] ramdata [0:3]; 
     always @(posedge clock) 
        #2 begin                            
             if(Memwrite==1)                     
                    ramdata[address[3:0]] <= write_data;
         end
         
     always @(*) 
         begin
             read_data <= ramdata[address[3:0]];
         end
     
endmodule