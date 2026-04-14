module barrel_shifter (
    input [31:0] data_in,
    input [5:0] control,
    output reg [31:0] data_out
);
    always @(*) begin
        case (control[5]) // direction
            1'b0: // left shift
                data_out = data_in << control[4:0];
            1'b1: // right shift
                data_out = data_in >> control[4:0];
        endcase
    end
endmodule