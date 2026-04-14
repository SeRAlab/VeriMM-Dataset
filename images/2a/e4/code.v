module sd_card_interface (
    input wire clk,
    input wire rst,
    input wire [3:0] command,
    output reg ready
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ready <= 0;
        end else begin
            case (command)
                4'b0000: ready <= 1; // Ready
                4'b0001: ready <= 0; // Not Ready
                4'b0010: ready <= 1; // Initialization
                4'b0011: ready <= 0; // Error
                default: ready <= 0;  // Reserved
            endcase
        end
    end
endmodule