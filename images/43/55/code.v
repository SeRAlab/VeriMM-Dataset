module top_module(
    input             clk,
    input             rst,

    input             hwrite,
    input      [31:0] hwdata,
    input      [31:0] haddr,
    input             hsel,
    output     [31:0] hrdata,

    input      [ 7:0] spi_data_out,
    input             spi_busy,
    output reg [ 7:0] spi_data_in,
    output reg        spi_ready_send
);reg [7:0] spi_data_out_reg;
reg [7:0] spi_data_in_reg;

assign hrdata = {{25'b0, phase || spi_busy || spi_ready_send, spi_busy ? spi_data_out_reg : spi_data_out}};

localparam IDLE = 0, DATA = 1;

reg phase;


always @(posedge clk) begin
    if (rst) begin
        spi_data_in <= 0;
        spi_ready_send <= 0;
        phase <= 0;
    end else if (spi_ready_send && spi_busy) begin
        spi_ready_send <= 0;
    end else if (!spi_ready_send && !spi_busy) begin
          if (!phase) begin
              if (hsel && haddr[15:0] == 'h0000 && hwrite) phase <= 1;
          end else begin
              spi_data_out_reg <= spi_data_in;
              spi_data_in <= spi_data_in_reg;
              spi_ready_send <= 1;
              phase <= 0;
          end
    end
end

always @(negedge clk) begin
    if (phase) spi_data_in_reg <= hwdata[7:0];
end

endmodule