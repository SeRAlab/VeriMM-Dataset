module top_module(
    input SCLK,
    input INTERRUPT,
    input CLOCK,
    output reg [7:0] DATA_IN,
    output reg [7:0] DATA_OUT,
    output reg NEW_DATA
);reg [7:0] tx_data;
reg [7:0] rx_data;
reg tx_en;
reg rx_en;
reg tx_done;
reg rx_done;
reg [2:0] bit_count;
reg [2:0] rx_bit_count;
reg [2:0] tx_bit_count;

always @(posedge CLOCK) begin
    if (tx_en) begin
        if (tx_bit_count == 0) begin
            tx_done <= 0;
            tx_data <= DATA_OUT;
        end else begin
            tx_data <= {1'b0, tx_data[7:1]};
        end
        tx_bit_count <= tx_bit_count + 1;
        if (tx_bit_count == 8) begin
            tx_en <= 0;
            tx_done <= 1;
            tx_bit_count <= 0;
        end
    end else if (rx_en) begin
        if (rx_bit_count == 0) begin
            rx_data <= 0;
        end else begin
            rx_data <= {rx_data[6:0], SCLK};
        end
        rx_bit_count <= rx_bit_count + 1;
        if (rx_bit_count == 8) begin
            rx_en <= 0;
            rx_bit_count <= 0;
            NEW_DATA <= 1;
        end
    end else begin
        if (INTERRUPT) begin
            rx_en <= 1;
        end
    end
end

always @(negedge SCLK) begin
    if (tx_en) begin
        DATA_IN <= rx_data;
    end else if (rx_en) begin
        DATA_IN <= DATA_IN;
    end else begin
        DATA_IN <= 0;
    end
end

always @(posedge SCLK) begin
    if (tx_done) begin
        rx_en <= 1;
    end
end

always @(posedge SCLK) begin
    if (tx_en == 0 && rx_en == 0 && INTERRUPT == 0) begin
        NEW_DATA <= 0;
    end
end

always @(posedge SCLK) begin
    if (tx_en == 0 && rx_en == 0 && INTERRUPT == 1) begin
        NEW_DATA <= 1;
    end
end

always @(posedge SCLK) begin
    if (tx_en == 0 && rx_en == 0 && INTERRUPT == 1) begin
        tx_en <= 1;
    end
end

endmodule