module priority_encoder (
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);

always @(*) begin
    valid = 0; // Initialize valid to 0
    casez (in)
        4'b1??? : begin // Input 3 is active
            out = 2'b11;
            valid = 1;
        end
        4'b01?? : begin // Input 2 is active
            out = 2'b10;
            valid = 1;
        end
        4'b001? : begin // Input 1 is active
            out = 2'b01;
            valid = 1;
        end
        4'b0001 : begin // Input 0 is active
            out = 2'b00;
            valid = 1;
        end
        default: begin // No active input
            out = 2'b00;
        end
    endcase
end
endmodule