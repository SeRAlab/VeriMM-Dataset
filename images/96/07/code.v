module Gray_counter_3(
   input                clk,
   input                rst_n,
   output reg [2:0]     Q  
);
    reg [2:0] binary_count;
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            binary_count <= 3'd0;
            Q <= 3'b000;
        end
        else begin
            binary_count <= binary_count + 1;
            Q <= binary_count ^ (binary_count >> 1);
        end
    end
endmodule