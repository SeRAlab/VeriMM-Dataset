module top_module(
    input rst, clk, baud_edge, data_ready,
    input [7:0] data,
    output reg tx, data_accepted
);localparam START = 2'b01, DATA = 2'b10, END = 2'b11;

    reg [7:0] data_reg;
    reg [2:0] state;
    reg [2:0] data_counter;
    reg [1:0] baud_counter;

    initial begin
        tx <= 1;
        data_accepted <= 0;
    end

    always @(posedge clk) begin
        if(rst) begin
            state <= END;
            tx <= 1;
            data_accepted <= 0;
            baud_counter <= 0;
        end else if(baud_edge) begin
            case(state)
            START: begin
                tx <= 0;
                data_counter <= 0;
                baud_counter <= 0;
                state <= DATA;
            end
            DATA: begin
                if(baud_counter == 0) begin
                    tx <= data_reg[data_counter];
                    if(data_counter != 7) begin
                        data_counter <= data_counter + 1;
                    end else begin
                        state <= END;
                        data_counter <= 0;
                    end
                end
                baud_counter <= baud_counter + 1;
            end
            END: begin
                tx <= 1;
                if(data_ready) begin
                    data_accepted <= 1;
                    data_reg <= data;
                    state <= START;
                end
            end
            default: begin
                tx <= 1;
                state <= END;
            end
            endcase
        end else begin
            baud_counter <= 0;
            data_accepted <= 0;
        end
    end
endmodule