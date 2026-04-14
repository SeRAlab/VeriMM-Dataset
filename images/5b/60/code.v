module top_module(
    input a,
    input b,
    output reg out_comb
);reg [1:0] stage1;
    reg [1:0] stage2;
    
    always @ (a, b) begin
        stage1[0] <= a ^ b;
        stage1[1] <= stage1[0];
        stage2[0] <= stage1[1];
        stage2[1] <= stage2[0];
        out_comb <= stage2[1];
    end
    
endmodule