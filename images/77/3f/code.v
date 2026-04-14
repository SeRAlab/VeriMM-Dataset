module top_module(
    input clk,
    input reset,
    input [49:0] in,
    input select,
    input load,
    input enable,
    output reg [49:0] q
);reg [49:0] rotator_out;
    reg [49:0] comb_out;
    reg [49:0] sub_out;
    reg [49:0] in_reg;
    reg [49:0] rotator_in;

    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 50'b0;
            q <= 50'b0;
            rotator_in <= 50'b0;
        end else begin
            if (load) begin
                in_reg <= in;
            end
            if (enable) begin
                if (select) begin
                    rotator_in <= {in_reg[0], in_reg};
                end else begin
                    rotator_in <= {in_reg[49:1]};
                end
                comb_out <= ~(in_reg[0] | in_reg[1] | in_reg[2] | in_reg[3]);
                rotator_out <= rotator_in;
                sub_out <= comb_out - rotator_out;
                q <= sub_out;
            end
        end
    end

endmodule