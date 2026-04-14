module top_module(
    input clk,
    input reset,
    input [31:0] data_in,
    output reg [31:0] data_out // Changed from wire to reg
);reg [7:0] A, B, C, D;
    reg [31:0] temp1, temp2;
    
    always @(posedge clk or negedge reset) begin // Changed `,` to `or`
        if (!reset) begin
            A <= 8'h00;
            B <= 8'h00;
            C <= 8'h00;
            D <= 8'h00;
            temp1 <= 32'h00000000;
            temp2 <= 32'h00000000;
            data_out <= 32'h00000000; // Initialize data_out on reset
        end else begin
            A <= {data_in[7:0], data_in[15:8], data_in[23:16], data_in[31:24]} << 2;
            B <= {data_in[7:0], data_in[15:8], data_in[23:16], data_in[31:24]} >> 2;
            C <= {data_in[31:24], data_in[23:16], data_in[15:8], data_in[7:0]};
            D <= {data_in[31:24], data_in[23:16], data_in[15:8], data_in[7:0]};
            
            temp1 <= {A, B, C ^ D};
            temp2 <= {A, B, (A & B) | (C ^ D)};
            data_out <= {temp1[31:24], temp1[23:16], temp2[15:8], temp2[7:0]} >> 3;
            data_out <= {data_out[30:0], data_out[31]} << 1;
        end
    end

endmodule