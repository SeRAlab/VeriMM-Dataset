module top_module(
    input clock,
    input resetn,
    input valid_in,
    output valid_out,
    input stall_in,
    output stall_out
);reg valid_out_reg;
reg stall_out_reg;

always @(posedge clock or negedge resetn) begin
    if (~resetn) begin
        valid_out_reg <= 1'b0;
        stall_out_reg <= 1'b0;
    end else begin
        if (valid_in && ~stall_in) begin
            valid_out_reg <= 1'b1;
            stall_out_reg <= 1'b0;
        end else begin
            valid_out_reg <= 1'b0;
            stall_out_reg <= 1'b1;
        end
    end
end

assign valid_out = valid_out_reg;
assign stall_out = stall_out_reg;

endmodule