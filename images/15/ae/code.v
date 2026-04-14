module deadbeat_controller(
    input [2:0] state,
    output reg [2:0] control
);

always @(*) begin
    control = 3'b000; // Default control
    case(state)
        3'b000: control = 3'b000; // Already at desired state
        3'b001: control = 3'b111; // Control to reach 000 from 001
        3'b010: control = 3'b101; // Control to reach 000 from 010
        3'b011: control = 3'b100; // Control to reach 000 from 011
        3'b100: control = 3'b011; // Control to reach 000 from 100
        3'b101: control = 3'b010; // Control to reach 000 from 101
        3'b110: control = 3'b001; // Control to reach 000 from 110
        3'b111: control = 3'b000; // Control to reach 000 from 111
        default: control = 3'b000; // Default case
    endcase
end
endmodule