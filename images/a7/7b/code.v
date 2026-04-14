module top_module(input clock, reset, en, r_w, input [7:0] abus, input [7:0] dbus_in, output [7:0] dbus_out);reg [7:0] m [0:128];
reg [7:0] data;
reg [7:0] i;

    always @(posedge clock) 
    begin
        if (reset == 1)
        begin
            m[0] <= 8'h00;
            m[1] <= 8'h01;
            m[2] <= 8'h02;
            m[3] <= 8'h03;
            m[4] <= 8'h04;
            data = 8'h00;
        end
        else if (en == 1 && r_w == 0) 
        begin
            data = dbus_in;
            m[abus] = dbus_in;
        end
        else if (en == 1 && r_w == 1) 
            data = m[abus];
        else
            data = 8'hZZ;
    end
    assign dbus_out = data;endmodule