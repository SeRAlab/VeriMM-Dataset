module top_module(
    input CLK,
    input CLR,
    input LD,
    input [3:0] DATA,
    output reg [3:0] Q0,
    output reg [3:0] Q1,
    output reg [3:0] Q2,
    output reg [3:0] Q3
);always @(posedge CLK or negedge CLR) begin
        if (CLR == 0) begin
            Q0 <= 0;
            Q1 <= 0;
            Q2 <= 0;
            Q3 <= 0;
        end
        else if (LD == 1) begin
            Q0 <= DATA[0];  // Correctly assign the first bit of DATA
            Q1 <= DATA[1];  // Correctly assign the second bit of DATA
            Q2 <= DATA[2];  // Correctly assign the third bit of DATA
            Q3 <= DATA[3];  // Correctly assign the fourth bit of DATA
        end
        else begin
            Q0 <= Q0 + 1;
            if (Q0 == 4'b1111) begin  // Corrected the overflow condition to 4'b1111
                Q0 <= 0;
                Q1 <= Q1 + 1;
                if (Q1 == 4'b1111) begin  // Corrected the overflow condition to 4'b1111
                    Q1 <= 0;
                    Q2 <= Q2 + 1;
                    if (Q2 == 4'b1111) begin  // Corrected the overflow condition to 4'b1111
                        Q2 <= 0;
                        Q3 <= Q3 + 1;
                        if (Q3 == 4'b1111) begin  // Corrected the overflow condition to 4'b1111
                            Q3 <= 0;
                        end
                    end
                end
            end
        end
    end

endmodule