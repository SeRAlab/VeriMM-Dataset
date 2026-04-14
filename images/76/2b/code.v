module binary_multiplier(
    input wire clk,
    input wire rst,
    input wire [3:0] multiplicand,    
    input wire [3:0] multiplier,    
    output reg [7:0] product
);

    reg [3:0] A;
    reg [3:0] Q;
    reg [7:0] P;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0;
            Q <= 4'b0;
            P <= 8'b0;
            count <= 4'b0;
        end else begin
            if (count == 4'b0) begin
                A <= multiplicand;
                Q <= multiplier;
                P <= 8'b0;
                count <= 4'd4;
            end else begin
                if (Q[0]) begin
                    P[7:4] <= P[7:4] + A;
                end
                P <= {P[6:0], Q[3]};
                Q <= Q >> 1;
                count <= count - 1;
            end
        end
    end

    assign product = P;
endmodule