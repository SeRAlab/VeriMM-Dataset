module divider_4bit (
    input clock,
    input reset,
    input enable,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    reg [3:0] count;
    
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0;
            remainder <= 4'b0;
            count <= 4'b0;
        end else if (enable) begin
            if (count < 4) begin
                remainder <= {remainder[2:0], dividend[3-count]};
                quotient <= {quotient[2:0], 1'b0};
                if (remainder >= divisor) begin
                    remainder <= remainder - divisor;
                    quotient[0] <= 1'b1;
                end
                count <= count + 1;
            end else begin
                count <= 4'b0; // Reset count after the operation
            end
        end
    end
endmodule