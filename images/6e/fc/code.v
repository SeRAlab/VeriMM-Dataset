module top_module(
    input [7:0] data_in,
    input shift,
    input load,
    output [7:0] data_out
);reg [7:0] shift_reg [2:0];
reg [1:0] stage;

always @(*) begin
    case(stage)
        0: begin
            if(load) begin
                shift_reg[0] <= data_in;
            end
            stage <= 1;
        end
        1: begin
            shift_reg[1] <= shift_reg[0];
            stage <= 2;
        end
        2: begin
            shift_reg[2] <= shift_reg[1];
            stage <= 3;
        end
        3: begin
            if(shift) begin
                shift_reg[2] <= {shift_reg[1][6:0], 1'b0};
            end else begin
                shift_reg[2] <= {1'b0, shift_reg[1][7:1]};
            end
            stage <= 1;
        end
    endcase
end

assign data_out = shift_reg[2];

endmodule