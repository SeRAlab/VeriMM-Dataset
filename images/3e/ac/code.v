module shift_register (
    input wire clk,
    input wire [15:0] data_in,
    input wire direction, // 0 for left shift, 1 for right shift
    output reg [15:0] data_out
);  
    always @(posedge clk) begin  
        if (direction == 0) begin // Left shift  
            data_out <= {data_out[14:0], 1'b0};  
        end else begin // Right shift  
            data_out <= {1'b0, data_out[15:1]};  
        end  
    end  
endmodule