module top_module(
    input [1:0] ctrl,
    input [3:0] data_in,
    input load,
    input clk,
    output reg [3:0] data_out,
    output reg valid
);reg [3:0] reg_data;

always @(posedge clk) begin
    if (load) begin
        reg_data <= data_in;
    end else begin
        case(ctrl)
            2'b00: begin
                data_out <= reg_data;
                valid <= 1'b1;
            end
            2'b01: begin
                data_out <= ~reg_data;
                valid <= 1'b1;
            end
            2'b10: begin
                data_out <= data_in;
                valid <= 1'b1;
            end
            2'b11: begin
                data_out <= ~data_in;
                valid <= 1'b1;
            end
            default: begin
                data_out <= 4'b0;
                valid <= 1'b0;
            end
        endcase
    end
end

initial begin
    reg_data = 4'b0;
end

endmodule