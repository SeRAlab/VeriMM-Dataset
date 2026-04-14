module top_module(
    input [29:0] background_data,
    input [39:0] foreground_data,
    output reg [9:0] new_red,
    output reg [9:0] new_green,
    output reg [9:0] new_blue
);always @ (*) begin
        if (foreground_data[39] == 1'b1) begin
            new_red = foreground_data[29:20];
            new_green = foreground_data[19:10];
            new_blue = foreground_data[9:0];
        end else begin
            new_red = background_data[29:20];
            new_green = background_data[19:10];
            new_blue = background_data[9:0];
        end
    end

endmodule