module priority_encoder (
    input [7:0] I,
    output reg [2:0] O
);
    always @(*) begin
        casez (I)
            8'b1??????? : O = 3'd0; // I0 active
            8'b01?????? : O = 3'd1; // I1 active
            8'b001????? : O = 3'd2; // I2 active
            8'b0001???? : O = 3'd3; // I3 active
            8'b00001??? : O = 3'd4; // I4 active
            8'b000001?? : O = 3'd5; // I5 active
            8'b0000001? : O = 3'd6; // I6 active
            8'b00000001 : O = 3'd7; // I7 active
            default      : O = 3'b000; // No input active
        endcase
    end
endmodule