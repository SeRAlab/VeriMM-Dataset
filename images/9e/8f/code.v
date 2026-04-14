module top_module(
    input clk,
    input a,
    input b,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);// 4-bit shift register module
    reg [3:0] shift_reg;
    always @(posedge clk) begin
        if (areset) begin
            shift_reg <= 4'b0;
        end else if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            if (a & b) begin
                shift_reg <= {shift_reg[2:0], 1'b0};
            end else if (a) begin
                shift_reg <= {shift_reg[2:0], 1'b1};
            end else if (b) begin
                shift_reg <= {1'b0, shift_reg[3:1]};
            end else begin
                shift_reg <= shift_reg;
            end
        end
    end

    // AND gate module
    reg and_out;
    always @(posedge clk) begin
        if (areset) begin
            and_out <= 1'b0;
        end else begin
            and_out <= a & b;
        end
    end

    // Output module
    always @(posedge clk) begin
        if (areset) begin
            q <= 4'b0;
        end else begin
            q <= shift_reg & and_out;
        end
    end

endmodule