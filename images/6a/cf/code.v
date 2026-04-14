module top_module(
    input [3:0] A, B,
    input CIN, BINV,
    input [1:0] OP,
    output reg COUT, // Changed COUT to reg type
    output reg [3:0] Y
);reg [3:0] B_inv;
reg [4:0] temp;

assign B_inv = B ^ 4'hF;

always @(*) begin
    case(OP)
        2'b00: begin // Add
            temp = {1'b0, A} + {1'b0, B} + CIN; // Added CIN to the addition
            COUT = temp[4]; // Updated index for carry-out
            Y = temp[3:0];
        end
        2'b01: begin // Sub
            temp = {1'b1, A} + {1'b0, B_inv} + CIN;
            COUT = temp[4]; // Updated index for carry-out
            Y = temp[3:0];
        end
        2'b10: begin // AND/OR
            if(BINV) begin // OR
                Y = A | B;
            end else begin // AND
                Y = A & B;
            end
            COUT = 1'b0; // Setting COUT to 0, not used in logical operations
        end
        2'b11: begin // Shift
            if(CIN) begin // Shift right
                Y = {A[3], A[3:1]};
            end else begin // Shift left
                Y = {A[2:0], 1'b0};
            end
            COUT = A[3]; // Set COUT to the leftmost bit for logical shift
        end
        default: begin
            $display("Error: Invalid operation code");
            COUT = 1'b0; // Default COUT
            Y = 4'b0000; // Default Y
        end
    endcase
end

endmodule