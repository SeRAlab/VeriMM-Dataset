module vending_machine (
    input clk,
    input areset,
    input coin,
    input stock,
    output reg [1:0] state);

    parameter IDLE = 2'b00, DISPENSE = 2'b01, OUT_OF_STOCK = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (coin && stock) state <= DISPENSE;
                    else if (!stock) state <= OUT_OF_STOCK;
                    else state <= IDLE;
                end
                DISPENSE: state <= IDLE;
                OUT_OF_STOCK: if (stock) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule