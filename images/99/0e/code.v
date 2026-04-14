module top_module(
    input clk,
    input rst,
    input en,
    input [1:0] mode,
    input [31:0] din,
    input we,
    input re,
    output [19:0] dout,
    output [1:0] status,
    output full,
    output empty
);reg [31:0] mem [0:7]; // 8-word deep memory
reg [3:0] wp; // write pointer
reg [4:0] rp; // read pointer
reg [1:0] status_reg; // status register
reg [19:0] dout_reg; // output data register
reg empty_reg; // empty register

assign dout = dout_reg;
assign status = status_reg;
assign empty = empty_reg;
assign full = (wp[2:0] == rp[3:1]) & (wp[3] != rp[4]);

wire [3:0] wp_p1 = wp + 1;
wire [4:0] rp_p1 = rp + 1; // Declare rp_p1 for incrementing rp

always @(posedge clk) begin
    if (rst) begin
        wp <= 4'h0;
        rp <= 5'h0;
        status_reg <= 2'h0;
        dout_reg <= 20'h0;
        empty_reg <= 1'b1;
    end else if (en) begin
        if (we) begin
            mem[wp[2:0]] <= din;
            wp <= wp_p1;
        end
        if (re) begin
            case (mode)
                2'h0: dout_reg <= {mem[rp[3:1]][15:0], 4'h0};
                2'h1: dout_reg <= {mem[rp[3:1]][17:0], 2'h0};
                2'h2: dout_reg <= mem[rp[3:1]];
            endcase
            rp <= (mode == 2'h0) ? rp_p1 : (rp + 2); // Use rp_p1 for incrementing
        end
        status_reg <= (wp[2:1] - rp[3:2]) - 2'h1;
        empty_reg <= (rp_p1[4:1] == wp[3:0]) & (mode == 2'h0 ? rp_p1[0] : 1'b1);
    end
end

endmodule