module top_module(
    input clk,
    input [7:0] r,
    input [7:0] g,
    input [7:0] b,
    input valid,

    output reg [11:0] chip_data,
    output reg chip_data_enable
);reg [23:0] pixel;
    always @(posedge clk) begin
        pixel <= {r, g, b};
        chip_data_enable <= valid;
    end

    
    always @(posedge clk or negedge clk)
        if (clk)
            chip_data <= pixel[11:0];
        else
            chip_data <= pixel[23:12];

endmodule