module top_module(
    input wire clk,
    input wire resetn,
    output wire [3:0] a_out,
    output wire [3:0] b_out,
    output wire [3:0] c_out
    );reg [3:0] cnt;
always @(posedge clk)
    if (resetn==0)
        cnt <= 0;
    else
        cnt <= cnt + 1;








reg [3:0] a;
always @(*)
    if (resetn==0)
        a <= 0;
    else
    begin
        if (cnt==0)
            a <= 0;
        else if (cnt==1)
            a <= 1;
        else
            a <= 2;
    end

reg [3:0] b;
always @(posedge clk)
    if (resetn==0)
        b <= 0;
    else
    begin
        if (cnt==0)
            b <= 0;
        else if (cnt==1)
            b <= 1;
        else
            b <= 2;
    end

assign a_out = a;
assign b_out = b;







reg [3:0] c;
always @(*)
    if (resetn==0)
        c <= 0;
    else
    begin
        if (cnt==0)
            c <= 0;
        else if (cnt==1)
            c <= 1;
        else if (cnt==2)
            c <= 2;
    end

assign c_out = c;

endmodule