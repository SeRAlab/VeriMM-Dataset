module BCD_counter(
   input                clk,
   input                rst_n,

   output reg [11:0]     Q
);
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Q <= 12'd0;
        else if(Q == 12'd999) Q <= 12'd0;
        else if(Q[3:0] == 4'd9) begin
            if(Q[7:4] == 4'd9) Q <= {Q[11:8] + 1, 8'd0};
            else Q <= {Q[11:8], Q[7:4] + 1, 4'd0};
        end else Q <= Q + 1;
    end
endmodule