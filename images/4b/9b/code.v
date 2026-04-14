module top_module(CLK, RST_I, RST_OUT);input CLK, RST_I;
    output RST_OUT;
    
    reg [4:0] cnt;
    reg rst_pulse;

    always @(posedge CLK or negedge RST_I) begin
        if (!RST_I) begin
            cnt <= 0;
            rst_pulse <= 0;
        end
        else if (cnt == 10) begin
            rst_pulse <= 0;
        end
        else if (rst_pulse == 0) begin
            cnt <= cnt + 1;
            rst_pulse <= 1;
        end
    end
    
    assign RST_OUT = rst_pulse;
    
endmodule