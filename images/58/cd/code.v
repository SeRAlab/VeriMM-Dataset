module top_module(
    input jd,
    input clk,
    output led6_r,led6_g
    );reg [24:0] count = 0;
    reg [1:0] light;
    always @(posedge clk)   count <= count + 1;
    always @(posedge count[24])
    begin
        if(jd)
            light=2'b01;
        else light=2'b10;
    end
    assign {led6_r,led6_g}=light;
endmodule