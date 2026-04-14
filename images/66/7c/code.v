module top_module(
    input wire[63:0] din_data,
    input wire din_last,
    output wire din_ready,
    input wire din_valid,
    output wire[63:0] dout_data,
    output wire dout_last,
    input wire dout_ready,
    output wire dout_valid
);reg[63:0] data_reg;
    reg last_reg;
    reg valid_reg;
    reg ready_reg;

    always @(posedge din_valid) begin
        if (din_ready) begin
            data_reg <= din_data;
            last_reg <= din_last;
            valid_reg <= 1'b1;
            ready_reg <= 1'b0;
        end
    end

    always @(posedge dout_ready) begin
        if (dout_valid) begin
            valid_reg <= 1'b0;
            ready_reg <= 1'b1;
        end
    end

    assign dout_data = data_reg;
    assign dout_last = last_reg;
    assign dout_valid = valid_reg;
    assign din_ready = ready_reg;

endmodule