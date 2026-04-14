module top_module(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input load,
    input ena,
    input valid_a,
    input ready_b,
    output ready_a,
    output reg valid_b,
    output reg [9:0] data_out,
    output reg [3:0] q
);reg [7:0] acc;
reg [3:0] shift_reg;

assign ready_a = ~valid_a || ready_b;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        acc <= 0;
        shift_reg <= 0;
        valid_b <= 0;
        data_out <= 0;
    end else if (ena) begin
        acc <= acc + data_in;
        if ((acc & 8'hFF) == 0) begin
            valid_b <= 1;
            data_out <= acc + {4'b0, shift_reg};
        end
        if (load) begin
            shift_reg <= data_in[3:0];
        end else if (ena) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end
end

assign q = shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_b <= 0;
    end else if (valid_a && ready_b) begin
        valid_b <= 0;
    end else if (valid_b && ready_a) begin
        valid_b <= 0;
    end else if (valid_a && valid_b) begin
        valid_b <= 1;
    end
end

endmodule