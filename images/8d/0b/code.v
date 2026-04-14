module presettable_counter(
    input               clk         ,   
    input               rst         ,
    input               preset      ,
    input [31:0]        preset_value,
 
    output  reg [31:0]  count
);
    
   //count logic
   always @(posedge clk or posedge rst) begin
       if(rst) begin
          count <= 0;
       end
       else if(preset) begin
          count <= preset_value;
       end
       else begin
          count <= count + 1;
       end
   end
     
endmodule