module top_module(
    input areset_d1,
    input aclk,
    input b_push,
    input si_rs_bready,
    input [1:0] m_axi_bresp,
    input m_axi_bvalid,
    input [8:0] in,
    output reg si_rs_bvalid,    // Changed to reg
    output reg cnt_read_reg_0_rep,
    output reg [1:0] cnt_read_reg_1_rep_0,
    output reg m_axi_bready,     // Changed to reg
    output reg [0:0] out,
    output reg [1:0] skid_buffer_reg_1
);reg [8:0] data_reg;
reg [1:0] cnt_read_reg;
reg [1:0] skid_buffer_reg;

always @(posedge aclk, posedge areset_d1) begin
    if (areset_d1) begin
        cnt_read_reg <= 2'b00;
        skid_buffer_reg <= 2'b00;
        si_rs_bvalid <= 1'b0;       // Initialize si_rs_bvalid
        m_axi_bready <= 1'b0;       // Initialize m_axi_bready
    end else begin
        if (b_push && m_axi_bvalid && m_axi_bresp == 2'b00) begin
            // write operation
            data_reg <= in;
            cnt_read_reg <= 2'b00;
            skid_buffer_reg <= 2'b00;
            si_rs_bvalid <= 1'b1;
            cnt_read_reg_0_rep <= 1'b0;
            cnt_read_reg_1_rep_0 <= 2'b00;
            m_axi_bready <= 1'b1;
            out <= 1'b0;
            skid_buffer_reg_1 <= 2'b00;
        end else if (b_push && m_axi_bvalid && m_axi_bresp == 2'b01) begin
            // read operation
            if (si_rs_bready) begin
                out <= data_reg;
                cnt_read_reg_0_rep <= 1'b1;
                cnt_read_reg_1_rep_0 <= cnt_read_reg;
                cnt_read_reg <= 2'b00;
                skid_buffer_reg_1 <= skid_buffer_reg;
                skid_buffer_reg <= 2'b00;
                si_rs_bvalid <= 1'b1;
                m_axi_bready <= 1'b1;
            end else begin
                cnt_read_reg <= cnt_read_reg + 1;
                si_rs_bvalid <= 1'b0;
                m_axi_bready <= 1'b0;
            end
        end else begin
            si_rs_bvalid <= 1'b0;
            m_axi_bready <= 1'b0;
        end
    end
end

endmodule