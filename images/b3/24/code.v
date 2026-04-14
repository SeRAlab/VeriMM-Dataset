module top_module( 
    input [99:0] in,
    input [1:0] select, // Select input to choose between AND, OR, and XOR outputs
    output reg out_and,
    output reg out_or,
    output reg out_xor 
);// Define intermediate wires for BDD
wire and_wire;
wire or_wire;
wire xor_wire;

// AND operation using BDD
assign and_wire = &in;

// OR operation using BDD
assign or_wire = |in;

// XOR operation using BDD
assign xor_wire = ^in;

// Control logic for selecting output
always @(*) begin
    case (select)
        2'b00: begin // AND selected
            out_and = and_wire;
            out_or  = 1'b0;
            out_xor = 1'b0;
        end
        2'b01: begin // OR selected
            out_and = 1'b0;
            out_or  = or_wire;
            out_xor = 1'b0;
        end
        2'b10: begin // XOR selected
            out_and = 1'b0;
            out_or  = 1'b0;
            out_xor = xor_wire;
        end
        default: begin
            out_and = 1'b0;
            out_or  = 1'b0;
            out_xor = 1'b0;
        end
    endcase
end

endmodule