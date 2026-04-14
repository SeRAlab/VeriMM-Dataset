module top_module(
    input clk,
    input [15:0] iline,
    output reg [15:0] oline,
    input [1:0] rw
);reg [15:0] reg_data;

always @(posedge clk) begin
    case(rw)
        2'b00: begin // Clear the register and output 16'h0
            reg_data <= 16'h0;
            oline <= 16'h0;
        end
        2'b01: begin // Output the stored data on the oline output
            oline <= reg_data;
        end
        2'b11: begin // Store the input data in the register and output the stored data on the oline output
            reg_data <= iline;
            oline <= reg_data;
        end
        default: begin
            reg_data <= reg_data;
            oline <= oline;
        end
    endcase
end

endmodule