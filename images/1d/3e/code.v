module priority_encoder(
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);
    always @* begin
        valid = 0;
        casez (in)
            4'b1??? : begin
                out = 2'b11; valid = 1; // Input 3 is highest
            end
            4'b01?? : begin
                out = 2'b10; valid = 1; // Input 2 is highest
            end
            4'b001? : begin
                out = 2'b01; valid = 1; // Input 1 is highest
            end
            4'b0001 : begin
                out = 2'b00; valid = 1; // Input 0 is highest
            end
            default : begin
                out = 2'b00; // Default case
                valid = 0; // No active input
            end
        endcase
    end
endmodule