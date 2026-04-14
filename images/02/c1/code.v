module ALU_Data_Forwarding(
    input [3:0] A,
    input [3:0] B,
    input [1:0] select,
    input [3:0] forwarded_data,
    output reg [3:0] result
);
    always @(*) begin
        case (select)
            2'b00: result = A + B; // Addition
            2'b01: result = A - B; // Subtraction
            2'b10: result = forwarded_data; // Forwarded data
            default: result = 4'b0000; // Default case
        endcase
    end
endmodule