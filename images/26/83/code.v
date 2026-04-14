module temp_sensor(
    input [4:0] temp,
    output overheat
);
assign overheat = (temp > 5'b10100) ? 1'b1 : 1'b0;
endmodule