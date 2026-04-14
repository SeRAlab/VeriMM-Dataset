module top_module(
    input clk, resetn,
    input s_sclk, s_sdo, s_sdo_t,
    output reg data_ready,
    output reg s_sdi,
    input s_cs,
    input spi_active
);parameter IDLE_TIMEOUT = 8;

wire m_sclk;
wire m_sdo;
wire m_sdo_t;
wire m_sdi; // Fixed: Declare m_sdi as a wire
wire m_cs;

assign m_sclk = s_sclk;
assign m_sdo = s_sdo;
assign m_sdo_t = s_sdo_t;
assign s_sdi = m_sdi;
assign m_cs = s_cs;

reg [$clog2(IDLE_TIMEOUT)-1:0] counter = IDLE_TIMEOUT;
reg [2:0] sdi_d = 'h00;

always @(posedge clk) begin
    if (resetn == 1'b0) begin
        counter <= IDLE_TIMEOUT;
    end else begin
        if (m_cs == 1'b0 && spi_active == 1'b0) begin // Fixed: Changed to use m_cs as it's not a bus
            if (counter != 'h00)
                counter <= counter - 1'b1;
        end else begin
            counter <= IDLE_TIMEOUT;
        end
    end
end

always @(posedge clk) begin
    /* The data ready signal is fully asynchronous */
    sdi_d <= {sdi_d[1:0], s_sdo}; // Fixed: Changed to use s_sdo directly
end

always @(posedge clk) begin
    if (counter == 'h00 && sdi_d[2] == 1'b0) begin
        data_ready <= 1'b1;
    end else begin
        data_ready <= 1'b0;
    end
end

endmodule