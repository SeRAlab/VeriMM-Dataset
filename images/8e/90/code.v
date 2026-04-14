module top_module(
    input clk,
    input rst,
    input mode,
    input dir,
    input [3:0] in,
    output [3:0] out
);reg [3:0] reg_out;
    reg [3:0] reg_in;
    reg [1:0] shift_dir;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            reg_out <= 4'd0;
            reg_in <= 4'd0;
            shift_dir <= 2'd0;
        end else if (mode == 1'b0) begin // Circular shift mode
            if (dir == 1'b0) begin // Right shift
                reg_out[0] <= reg_in[3];
                reg_out[1] <= reg_in[0];
                reg_out[2] <= reg_in[1];
                reg_out[3] <= reg_in[2];
            end else begin // Left shift
                reg_out[0] <= reg_in[1];
                reg_out[1] <= reg_in[2];
                reg_out[2] <= reg_in[3];
                reg_out[3] <= reg_in[0];
            end
            reg_in <= reg_out;
        end else begin // Linear shift mode
            if (dir == 1'b0) begin // Right shift
                if (shift_dir == 2'd0) begin
                    reg_out <= {reg_in[3], reg_in[0], reg_in[1], reg_in[2]};
                    shift_dir <= 2'd1;
                end else begin
                    reg_out <= {reg_out[3], reg_in[0], reg_in[1], reg_in[2]};
                end
            end else begin // Left shift
                if (shift_dir == 2'd0) begin
                    reg_out <= {reg_in[1], reg_in[2], reg_in[3], reg_in[0]};
                    shift_dir <= 2'd1;
                end else begin
                    reg_out <= {reg_in[1], reg_in[2], reg_in[3], reg_out[0]};
                end
            end
            reg_in <= in;
        end
    end

    assign out = (mode == 1'b0) ? reg_out : reg_in;

endmodule