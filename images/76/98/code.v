module verified_Gray_counter(
   input                clk ,
   input                rst_n,
 
   output reg [7:0]     Q  
);
    reg [7:0] binary;
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 8'b0;
            binary <= 8'b0;
        end else begin
            binary <= binary + 1;
            Q <= (binary >> 1) ^ binary;
        end
    end
endmodule