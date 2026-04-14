module verified_UpDown_counter(
   input                clk ,
   input                rst_n,
   input                en,
   input                up_down,
 
   output reg [15:0]    count  
);
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) count <= 16'b0;
        else if (en) begin
            if (up_down) count <= count + 1;
            else count <= count - 1;
        end
    end
endmodule