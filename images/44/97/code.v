module top_module(clk, rst_, ena_, rdy_,
    mem_we_, abus, dbus,
    r0_dout, r1_dout);input clk;
    input rst_;
    input ena_;
    output rdy_;
    output mem_we_;
    output[7:0] abus;
    output[7:0] dbus;
    input[7:0] r0_dout, r1_dout;

    reg rdy_en;
    assign rdy_ = rdy_en ? 1'b0 : 1'bZ;
    reg mem_we_en;
    assign mem_we_ = mem_we_en ? 1'b0 : 1'bZ;
    reg bus_en;
    assign abus = bus_en ? r1_dout : 8'bZ;
    assign dbus = bus_en ? r0_dout : 8'bZ;
    reg[1:0] state;

    always @(negedge rst_ or posedge clk)
        if(!rst_) begin
            rdy_en <= 0;
            bus_en <= 0;
            state <= 0;
        end else begin
            
            rdy_en <= state[1];
            bus_en <= state[0] | ~ena_;
            state <= {state[0], ~ena_};
        end

    always @(negedge rst_ or negedge clk)
        if(!rst_)
            mem_we_en <= 0;
        else
            
            mem_we_en <= state[0];

endmodule