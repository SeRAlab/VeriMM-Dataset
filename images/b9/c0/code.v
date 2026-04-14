module Gray_code_counter_24(
   input                clk,
   input                rst_n,
   
   output reg [23:0]    Q
);
    reg [23:0] binary_count;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) binary_count <= 24'd0;
        else binary_count <= binary_count + 24'd1;
    end
    
    always@(binary_count)begin
        Q = (binary_count >> 1) ^ binary_count;
    end
endmodule