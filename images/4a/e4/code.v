module gray_code_counter_4(
   input                clk,
   input                rst_n,

   output reg [3:0]     Q
);
    reg [3:0] binary_count;
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            binary_count <= 4'b0000;
            Q <= 4'b0000;
        end else begin
            binary_count <= binary_count + 1;
            Q <= binary_count ^ (binary_count >> 1);
        end
    end
endmodule