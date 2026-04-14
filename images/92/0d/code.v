module top_module(
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z );wire [2:0] temp = {A,B,C};
    reg [7:0] Q;
    
    assign Z = Q[temp];
    
    always @(posedge clk) begin
        if (enable == 1'b1) begin
            Q[0] <= S;
            Q[1] <= Q[0];
            Q[2] <= Q[1];
            Q[3] <= Q[2];
            Q[4] <= Q[3];
            Q[5] <= Q[4];
            Q[6] <= Q[5];
            Q[7] <= Q[6]; end
    end
    
endmodule