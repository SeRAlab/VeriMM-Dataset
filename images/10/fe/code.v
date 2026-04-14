module divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] divd;
    reg [7:0] divs;
    reg [4:0] count;
    reg state;
    
    localparam IDLE = 1'b0;
    localparam DIVIDE = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            divd <= 8'b0;
            divs <= 8'b0;
            count <= 5'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 0) begin
                        divd <= dividend;
                        divs <= divisor;
                        quotient <= 8'b0;
                        remainder <= 8'b0;
                        count <= 8; // 8 bits to process
                        state <= DIVIDE;
                    end
                end
                
                DIVIDE: begin
                    if (count > 0) begin
                        remainder <= {remainder[6:0], divd[7]};
                        divd <= {divd[6:0], 1'b0};
                        if (remainder >= divs) begin
                            remainder <= remainder - divs;
                            quotient <= {quotient[6:0], 1'b1};
                        end else begin
                            quotient <= {quotient[6:0], 1'b0};
                        end
                        count <= count - 1;
                    end else begin
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule