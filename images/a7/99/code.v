module Counter_12_tc(
   input                clk,
   input                rst,
   input                en,
   output reg [11:0]    Q,
   output reg           tc
);
    always@(posedge clk)begin
        if(rst) begin
            Q <= 12'd0;
            tc <= 1'b0;
        end else if(en) begin
            if(Q == 12'd4095) begin
                Q <= 12'd0;
                tc <= 1'b1;
            end else begin
                Q <= Q + 1;
                tc <= 1'b0;
            end
        end
    end
endmodule