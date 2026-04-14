module top_module(
    input a, b, c, control,
    output w, x, y, z
);wire selected_input;

assign selected_input = (control == 0) ? a :
                        (control == 1) ? b :
                        c;

assign w = selected_input;
assign x = selected_input;
assign y = selected_input;
assign z = selected_input;

endmodule