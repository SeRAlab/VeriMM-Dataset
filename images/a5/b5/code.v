module top_module(
    input [3:0] temp,
    output TempLeve,
    output TempNormal,
    output TempGrave
    );assign TempNormal=(~(temp[1]|temp[2]))&temp[3];
assign TempLeve=temp[1]&((~temp[3]&temp[2]&temp[0])|(temp[3]&~(temp[2]|temp[0])));
assign TempGrave=~(temp[3]|temp[2])|(temp[2]&~(temp[1]&temp[0]))|(temp[3]&temp[1]&temp[0]);

endmodule