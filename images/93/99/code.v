module top_module(
    input [3:0] gpio_io_i,
    input s_axi_aclk,
    output reg [3:0] scndry_vect_out
);reg [3:0] s_level_out_bus_d1_cdc_to_0;
reg [3:0] s_level_out_bus_d1_cdc_to_1;
reg [3:0] s_level_out_bus_d1_cdc_to_2;
reg [3:0] s_level_out_bus_d1_cdc_to_3;
reg [3:0] s_level_out_bus_d2_0;
reg [3:0] s_level_out_bus_d2_1;
reg [3:0] s_level_out_bus_d2_2;
reg [3:0] s_level_out_bus_d2_3;
reg [3:0] s_level_out_bus_d3_0;
reg [3:0] s_level_out_bus_d3_1;
reg [3:0] s_level_out_bus_d3_2;
reg [3:0] s_level_out_bus_d3_3;

// Synchronize the input signals using the FDRE primitive
always @(posedge s_axi_aclk)
begin
    s_level_out_bus_d1_cdc_to_0 <= gpio_io_i[0];
    s_level_out_bus_d1_cdc_to_1 <= gpio_io_i[1];
    s_level_out_bus_d1_cdc_to_2 <= gpio_io_i[2];
    s_level_out_bus_d1_cdc_to_3 <= gpio_io_i[3];
end

// Create a delay using a chain of FDRE primitives
always @(posedge s_axi_aclk)
begin
    s_level_out_bus_d2_0 <= s_level_out_bus_d1_cdc_to_0;
    s_level_out_bus_d2_1 <= s_level_out_bus_d1_cdc_to_1;
    s_level_out_bus_d2_2 <= s_level_out_bus_d1_cdc_to_2;
    s_level_out_bus_d2_3 <= s_level_out_bus_d1_cdc_to_3;
end

always @(posedge s_axi_aclk)
begin
    s_level_out_bus_d3_0 <= s_level_out_bus_d2_0;
    s_level_out_bus_d3_1 <= s_level_out_bus_d2_1;
    s_level_out_bus_d3_2 <= s_level_out_bus_d2_2;
    s_level_out_bus_d3_3 <= s_level_out_bus_d2_3;
end

// Synchronize the delayed signals using the FDRE primitive
always @(posedge s_axi_aclk)
begin
    scndry_vect_out[0] <= s_level_out_bus_d3_0;
    scndry_vect_out[1] <= s_level_out_bus_d3_1;
    scndry_vect_out[2] <= s_level_out_bus_d3_2;
    scndry_vect_out[3] <= s_level_out_bus_d3_3;
end

endmodule