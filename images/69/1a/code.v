module top_module(
    input rst,
    input clk,
    input [23:0] addr,
    output reg [15:0] dout,
    output reg rdy,
    output reg sram_clk,
    output reg sram_adv,
    output reg sram_cre,
    output reg sram_ce,
    output reg sram_oe,
    output reg sram_lb,
    output reg sram_ub,
    output reg [23:1] sram_addr,
    output reg sram_we,
    inout [15:0] sram_data
);reg [2:0] state = 3'b000;

always @(posedge clk) begin
    if (!rst) begin
        state <= 3'b000;
        rdy <= 1'b1;
        dout <= 16'h0000;
        sram_ce <= 1'b0;
        sram_oe <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // idle
                rdy <= 1'b1;
                if (addr[0] == 1'b1) begin
                    sram_addr <= {addr[23:1], 1'b0};
                    sram_ce <= 1'b1;
                    sram_oe <= 1'b1;
                    state <= 3'b001;
                end
            end
            3'b001: begin // read
                sram_ce <= 1'b1;
                sram_oe <= 1'b1;
                dout <= sram_data;
                state <= 3'b010;
            end
            3'b010: begin // output
                sram_ce <= 1'b0;
                sram_oe <= 1'b0;
                state <= 3'b000;
            end
        endcase
    end
end

endmodule