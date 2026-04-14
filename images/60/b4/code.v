module down_counter(
   input                clk ,
   input                rst,
   input                load,
   input                en,
   input  [31:0]        load_val,
 
   output reg [31:0]    count  
);
    always@(posedge clk)begin
        if(rst) 
            count <= 32'd0;
        else if(load) 
            count <= load_val;
        else if(en) 
            count <= count - 1;
    end
endmodule