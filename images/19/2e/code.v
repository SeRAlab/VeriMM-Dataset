module pcie_endpoint_controller (
    input clk,
    input reset,
    input [3:0] command,
    output reg [7:0] data,
    output reg ready
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data <= 8'b0;
            ready <= 1'b0;
        end else begin
            case (command)
                4'b0001: begin // command 1
                    data <= 8'hAA; // example data
                    ready <= 1'b1;
                end
                4'b0010: begin // command 2
                    data <= 8'hBB; // example data
                    ready <= 1'b1;
                end
                default: begin
                    data <= 8'b0;
                    ready <= 1'b0;
                end
            endcase
        end
    end
endmodule