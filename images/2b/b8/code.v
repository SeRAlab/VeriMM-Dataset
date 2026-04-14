module dwt_haar (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] approx_out,
    output reg [7:0] detail_out,
    output reg valid_out
);
    reg [7:0] sample1, sample2;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sample1 <= 0;
            sample2 <= 0;
            valid_out <= 0;
            state <= 0;
        end else if (valid_in) begin
            case (state)
                0: begin
                    sample1 <= data_in;
                    state <= 1;
                end
                1: begin
                    sample2 <= data_in;
                    approx_out <= (sample1 + sample2) >> 1; // Average
                    detail_out <= (sample1 - sample2); // Difference
                    valid_out <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule