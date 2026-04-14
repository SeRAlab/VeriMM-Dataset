module sync_up_down_counter_8bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire up_down,
    input wire load,
    input wire [7:0] load_value,
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
        end else if (load) begin
            count <= load_value;
        end else if (en) begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule