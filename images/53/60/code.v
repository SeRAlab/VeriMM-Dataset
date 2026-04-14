module counter_64bit (
    input wire clk,
    input wire rst,
    output reg [63:0] q
);

    wire [15:0] q1, q2, q3, q4;

    counter_16bit cnt1 (
        .clk(clk),
        .rst(rst),
        .q(q1)
    );

    counter_16bit cnt2 (
        .clk(clk),
        .rst(rst),
        .q(q2)
    );

    counter_16bit cnt3 (
        .clk(clk),
        .rst(rst),
        .q(q3)
    );

    counter_16bit cnt4 (
        .clk(clk),
        .rst(rst),
        .q(q4)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 64'b0;
        end else begin
            q <= {q1, q2, q3, q4};
        end
    end

endmodule

module counter_16bit (
    input wire clk,
    input wire rst,
    output reg [15:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 16'b0;
        end else begin
            q <= q + 1;
        end
    end

endmodule