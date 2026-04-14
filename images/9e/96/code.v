module top_module( output SO, input S_in, input [7: 0] data, input load, Shift_control, Clock, reset_b);reg [7: 0] SReg;
    assign SO = SReg[0];
    always @ ( posedge Clock, negedge reset_b)
        if (reset_b == 0) SReg <= 0;
        else if (load) SReg <= data;
        else if (Shift_control) SReg <= {S_in, SReg[7: 1]};endmodule