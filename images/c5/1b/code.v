module barrel_shift (
    input [3:0] DATA,
    input [1:0] SHIFT,
    output [3:0] RESULT
);

    assign RESULT = (SHIFT == 2'b00) ? DATA :
                    (SHIFT == 2'b01) ? {DATA[0], DATA[3:1]} :
                    (SHIFT == 2'b10) ? {DATA[1:0], DATA[3:2]} :
                    {DATA[2:0], DATA[3]};

endmodule