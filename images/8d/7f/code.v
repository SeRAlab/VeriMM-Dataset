module top_module(nrst, clk, cs, sck, si, cs_s, sck_p, sck_n, si_s);input nrst;
    input clk;
    input cs;
    input sck;
    input si;
    output cs_s;
    output sck_p;
    output sck_n;
    output si_s;
    reg [1:0] cs_r;
    reg [1:0] si_r;
    reg [2:0] sck_r;
    
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            sck_r <= 3'b111;
            cs_r <= 2'b11;
            si_r <= 2'b00;
        end else begin
            sck_r <= {sck_r[1:0], sck};
            cs_r <= {cs_r[0], cs};
            si_r <= {si_r[0], si};
        end
    end
    
    assign sck_p = (sck_r[2:1] == 2'b01);
    assign sck_n = (sck_r[2:1] == 2'b10);
    assign cs_s = cs_r[1];
    assign si_s = si_r[1];
endmodule