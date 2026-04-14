module top_module(
    input clk,
    input rst_n,
    input select,
    output reg [15:0] q
);reg [15:0] jc1, jc2, sum;
wire x;

// First Johnson counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        jc1 <= 16'b0000000000000000;
    end else begin
        jc1 <= {jc1[14:0], ~jc1[15]};
    end
end

// Second Johnson counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        jc2 <= 8'b00000000;
    end else begin
        jc2 <= {jc2[6:0], ~jc2[7]};
    end
end

// XOR gate to generate x
assign x = jc1[15] ^ jc2[7];

// Functional module to calculate sum
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'b0000000000000000;
    end else begin
        if (select) begin
            sum <= jc2 + {8'b00000000, jc1};
        end else begin
            sum <= jc1 + {8'b00000000, jc2};
        end
    end
end

// Output q based on select
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 16'b0000000000000000;
    end else begin
        if (select) begin
            q <= sum[15:0];
        end else begin
            q <= sum[7:0];
        end
    end
end

endmodule