module divider (
    input clk,
    input reset,
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    reg [3:0] count;
    reg [3:0] temp_numerator;
    reg [3:0] temp_denominator;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 0;
            remainder <= 0;
            valid <= 0;
            count <= 0;
        end else begin
            if (count < 4) begin
                temp_numerator <= (count == 0) ? numerator : {remainder[2:0], 1'b0};
                temp_denominator <= denominator;
                
                if (temp_numerator >= temp_denominator) begin
                    remainder <= temp_numerator - temp_denominator;
                    quotient <= (count == 0) ? 1 : {quotient[2:0], 1'b1};
                end else begin
                    remainder <= temp_numerator;
                    quotient <= (count == 0) ? 0 : {quotient[2:0], 1'b0};
                end
                
                count <= count + 1;
                if (count == 3) valid <= 1;
            end
        end
    end
endmodule