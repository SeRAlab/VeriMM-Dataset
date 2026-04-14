module Gray_counter_4(
   input                clk,
   input                rst_n,
   output reg [3:0]     Q  
);
    reg [3:0] binary_counter;
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) binary_counter <= 4'd0;
        else binary_counter <= binary_counter + 1;
    end
    
    always@* begin
        Q = binary_counter ^ (binary_counter >> 1);
    end
endmodule