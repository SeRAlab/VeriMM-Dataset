module current_sensor(
    input [4:0] current_input,
    output current_exceeds
);
    assign current_exceeds = (current_input > 5'b10100) ? 1'b1 : 1'b0;
endmodule