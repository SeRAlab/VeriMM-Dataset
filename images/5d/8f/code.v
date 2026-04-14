module top_module(
    input [7:0] A,
    input [7:0] B,
    input start,
    output reg [15:0] P
);reg [7:0] B_temp;
    reg [3:0] i;
    reg [7:0] A_temp;
    reg [15:0] P_temp;
    
    always @(*) begin
        P_temp = 0;
        A_temp = A;
        B_temp = B;
        if (start) begin
            for(i=0; i<8; i=i+1) begin
                if (B_temp[0] == 1) begin
                    P_temp = P_temp + (A_temp << i);
                end
                B_temp = B_temp >> 1;
            end
            P = P_temp;
        end
    end
endmodule