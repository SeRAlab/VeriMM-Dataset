module gray_code_counter(
   input                clk,
   input                rst_n,

   output reg [7:0]     Q
);
    reg [7:0] binary_count;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            binary_count <= 8'd0;
            Q <= 8'd0;
        end else begin
            binary_count <= binary_count + 1;
            Q <= (binary_count >> 1) ^ binary_count;
        end
    end
endmodule