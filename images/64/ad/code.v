module top_module(
    input clk,
    input [2:0] sel,
    input [3:0] data,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);reg [3:0] data_reg1;
reg [3:0] data_reg2;
reg [3:0] data_reg3;

always @(posedge clk) begin
    data_reg1 <= data;
end

always @(posedge clk) begin
    data_reg2 <= data_reg1;
end

always @(posedge clk) begin
    data_reg3 <= data_reg2;
end

always @(posedge clk) begin
    case(sel)
        3'b000: begin
            w <= data_reg3[0];
            x <= data_reg3[1];
            y <= data_reg3[2];
            z <= data_reg3[3];
        end
        3'b001: begin
            w <= data_reg2[0];
            x <= data_reg2[1];
            y <= data_reg2[2];
            z <= data_reg2[3];
        end
        3'b010: begin
            w <= data_reg1[0];
            x <= data_reg1[1];
            y <= data_reg1[2];
            z <= data_reg1[3];
        end
        3'b011: begin
            w <= 0;
            x <= 0;
            y <= 0;
            z <= 0;
        end
        default: begin
            w <= 0;
            x <= 0;
            y <= 0;
            z <= 0;
        end
    endcase
end

endmodule