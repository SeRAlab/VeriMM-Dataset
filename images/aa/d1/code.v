module top_module(
    input clk,
    input rst,
    input start,
    input [7:0] a,
    input [7:0] b,
    output reg done,
    output reg [15:0] result
);reg [7:0] m;
    reg [7:0] q;
    reg [4:0] i;
    reg [8:0] ac;

    always @(posedge clk) begin
        if (rst) begin
            done <= 0;
            result <= 0;
            m <= 0;
            q <= 0;
            i <= 0;
            ac <= 0;
        end else begin
            if (start) begin
                done <= 0;
                result <= 0;
                m <= b;
                q <= a;
                i <= 4;
                ac <= {1'b0, q, 8'b0};  // Initialize ac with MSB 0
            end else if (!done) begin
                if (ac[1:0] == 2'b01) begin  // Corrected part select order
                    ac <= ac + m;
                end else if (ac[1:0] == 2'b10) begin  // Corrected part select order
                    ac <= ac - m;
                end

                if (ac[0]) begin
                    q <= {q[6:0], 1'b1};
                    ac <= ac + m;
                end else begin
                    q <= {q[6:0], 1'b0};
                end

                i <= i - 1;

                if (i == 0) begin
                    done <= 1;
                    result <= ac[15:0];  // Output the final result
                end
            end
        end
    end

endmodule