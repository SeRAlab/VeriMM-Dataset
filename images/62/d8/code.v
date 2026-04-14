module top_module(
    input wire clk,
    input wire water_in,
    input wire water_out,
    output reg [2:0] water_level,
    output reg water_in_end_sign,
    output reg water_out_end_sign
);reg [2:0] next_water_level;

always @(posedge clk) begin
    if (water_in && !water_out && water_level != 3'b100) begin
        next_water_level = water_level + 1;
    end
    else if (!water_in && water_out && water_level != 3'b000) begin
        next_water_level = water_level - 1;
    end
    else begin
        next_water_level = water_level;
    end
    
    if (next_water_level == 3'b100) begin
        water_in_end_sign = 1'b1;
    end
    else begin
        water_in_end_sign = 1'b0;
    end
    
    if (next_water_level == 3'b000) begin
        water_out_end_sign = 1'b1;
    end
    else begin
        water_out_end_sign = 1'b0;
    end
    
    water_level <= next_water_level;
end

endmodule