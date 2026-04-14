module top_module(clk,r_a,r_b,r_d,r_e
    );input clk;
         input r_a;
         input r_b;
         output reg r_d,r_e;
always @(posedge clk) begin
        if(r_a==1 && r_b==1) begin
        r_e<=1;
        end
        if(r_a==0 && r_b==0) begin
        r_e<=0;
        end
        if(r_a==1 && r_b==0) begin
        r_d<=0;
        end
        if(r_a==0 && r_b==1) begin
        r_d<=1;
        end
end
endmodule