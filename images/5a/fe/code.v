module top_module(
    input wire          BUS_CLK,
    input wire          BUS_RST,
    input wire  [15:0]  BUS_ADD,
    inout wire  [7:0]   BUS_DATA_IN,
    output wire [7:0]   BUS_DATA_OUT_1,
    output wire [7:0]   BUS_DATA_OUT_2,
    input wire          BUS_RD,
    input wire          BUS_WR
);localparam GPIO_BASEADDR = 16'h0000;
localparam GPIO_HIGHADDR = 16'h000f;

localparam GPIO2_BASEADDR = 16'h0010;
localparam GPIO2_HIGHADDR = 16'h001f;

reg [7:0] gpio_data_1;
reg [7:0] gpio_data_2;

// Connect input data bus to tri-state buffer
assign BUS_DATA_IN = (BUS_ADD >= GPIO_BASEADDR && BUS_ADD <= GPIO_HIGHADDR) ? gpio_data_1 :
                     (BUS_ADD >= GPIO2_BASEADDR && BUS_ADD <= GPIO2_HIGHADDR) ? gpio_data_2 : 8'bz;

// Connect output data buses to registers
assign BUS_DATA_OUT_1 = (BUS_ADD >= GPIO_BASEADDR && BUS_ADD <= GPIO_HIGHADDR) ? gpio_data_1 : 8'bz;
assign BUS_DATA_OUT_2 = (BUS_ADD >= GPIO2_BASEADDR && BUS_ADD <= GPIO2_HIGHADDR) ? gpio_data_2 : 8'bz;

always @(posedge BUS_CLK) begin
    if (BUS_RST) begin
        gpio_data_1 <= 8'b0;
        gpio_data_2 <= 8'b0;
    end else if (BUS_WR) begin
        if (BUS_ADD >= GPIO_BASEADDR && BUS_ADD <= GPIO_HIGHADDR) begin
            gpio_data_1 <= BUS_DATA_IN;
        end else if (BUS_ADD >= GPIO2_BASEADDR && BUS_ADD <= GPIO2_HIGHADDR) begin
            gpio_data_2 <= BUS_DATA_IN;
        end
    end
end

endmodule