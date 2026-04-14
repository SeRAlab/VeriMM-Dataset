module top_module(
    input [7:0] in,
    input [2:0] shift,
    input direction,
    output reg [7:0] out
);always @(*) begin
        if (direction == 0) begin // Left shift
            case (shift)
                3'd0: out = in;
                3'd1: out = {in[6:0], 1'b0};
                3'd2: out = {in[5:0], 2'b00};
                3'd3: out = {in[4:0], 3'b000};
                3'd4: out = {in[3:0], 4'b0000};
                3'd5: out = {in[2:0], 5'b00000};
                3'd6: out = {in[1:0], 6'b000000};
                3'd7: out = {1'b0, 7'b0000000};
            endcase
        end else begin // Right shift
            case (shift)
                3'd0: out = in;
                3'd1: out = {1'b0, in[7:1]};
                3'd2: out = {2'b00, in[7:2]};
                3'd3: out = {3'b000, in[7:3]};
                3'd4: out = {4'b0000, in[7:4]};
                3'd5: out = {5'b00000, in[7:5]};
                3'd6: out = {6'b000000, in[7:6]};
                3'd7: out = {7'b0000000, 1'b0};
            endcase
        end
    end

endmodule