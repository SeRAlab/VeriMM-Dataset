module shift_register_8bit
(
    input clk,
    input rst_n,
    input load,
    input shift_dir,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 8'b0;
    end
    else if (load) begin
        data_out <= data_in;
    end
    else begin
        if (shift_dir) begin
            data_out <= {data_out[0], data_out[7:1]};
        end
        else begin
            data_out <= {data_out[6:0], data_out[7]};
        end
    end
end

endmodule