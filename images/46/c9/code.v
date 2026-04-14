module top_module(O, I0, I1, I2, I3, S0, S1);output reg O; // Change output O to reg type
    input I0, I1, I2, I3, S0, S1;

    reg [3:0] data;
    reg [1:0] sel;

    always @ (S1 or S0 or I0 or I1 or I2 or I3)
        begin
            sel = {S1, S0};
            case (sel)
                2'b00: data = I0;
                2'b01: data = I1;
                2'b10: data = I2;
                2'b11: data = I3;
            endcase
            O = data; // Now O can be assigned since it's declared as reg
        end

endmodule