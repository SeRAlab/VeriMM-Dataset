module top_module(
    clk,
    ena,
    radical,
    q,
    remainder
);input clk;
input ena;
input [42:0] radical;
output reg [21:0] q;
output reg [22:0] remainder;

reg [21:0] sub_wire0;
reg [22:0] sub_wire1;

reg [42:0] x;
reg [21:0] y;
reg [21:0] y_next;
reg [42:0] r;
reg [42:0] r_next;
reg [21:0] q_next;
reg [42:0] x_next;
reg [22:0] remainder_next;

assign x = radical;
assign y = {11'b0, 11'b1, 11'b0, 11'b1, 11'b0, 11'b1, 11'b0, 11'b1, 11'b0, 11'b1, 11'b0};
assign r = {21'b0, radical};

always @(*) begin
    q_next = {21'b0, y[42:32]};
    x_next = {r[42:22], y[31:0]};
    y_next = y + q_next;
    r_next = r - x_next * q_next;
end

always @(posedge clk) begin
    if (ena) begin
        q <= sub_wire0;
        remainder <= sub_wire1;
        
        sub_wire0 <= q_next;
        sub_wire1 <= remainder_next;
    end
end

genvar i;
generate
    for (i = 0; i < 5; i = i + 1) begin: loop_block
        always @(posedge clk) begin
            if (ena) begin
                q_next <= {q_next[20:0], 1'b0}; 
                remainder_next <= {remainder_next[21:0], 1'b0};
                if (r_next[42]) begin
                    q_next[0] <= 1'b0;
                    r_next <= r_next + x_next;
                end else begin
                    q_next[0] <= 1'b1;
                end
                x_next <= {x_next[41:0], 1'b0};
                y_next <= {y_next[20:0], 1'b0};
            end
        end
    end
endgenerate

endmodule