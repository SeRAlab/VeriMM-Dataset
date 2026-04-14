module shift_reg (
    input [7:0] data_in,
    input shift,
    input load,
    output reg [7:0] data_out
);

    reg [7:0] shift_reg;

    always @ (posedge shift) begin
        shift_reg <= {shift_reg[6:0], 1'b0};
    end

    always @ (posedge load) begin
        shift_reg <= data_in;
    end

    assign data_out = shift_reg;

endmodule