module top_module(
    input SBCLKI,
    input SBRWI,
    input SBSTBI,
    input [7:0] SBADRI,
    input [7:0] SBDATI,
    output reg [7:0] SBDATO,
    output reg SBACKO,
    output reg I2CIRQ,
    output I2CWKUP,
    output SCLO,
    output SCLOE,
    output SDAO,
    output SDAOE
);parameter I2C_SLAVE_INIT_ADDR = 8'b11111000; // Fixed: Changed to 8 bits
parameter BUS_ADDR74 = 4'b0001;

reg [7:0] i2c_address;
reg [7:0] i2c_data;
reg i2c_busy;
reg i2c_ack;
reg i2c_irq;
reg i2c_wakeup;
reg scl;
reg sda;

assign SBDATO = i2c_data;
assign SBACKO = i2c_ack;
assign I2CIRQ = i2c_irq;
assign I2CWKUP = i2c_wakeup;
assign SCLO = scl;
assign SDAO = sda;
assign SCLOE = 1;
assign SDAOE = 1;

always @(posedge SBCLKI) begin
    if(SBSTBI && !i2c_busy) begin
        i2c_address <= SBADRI;
        i2c_busy <= 1;
    end else if(SBRWI && i2c_busy) begin
        i2c_data <= SBDATI;
        i2c_ack <= 1;
        i2c_irq <= 1;
        i2c_wakeup <= 1;
        i2c_busy <= 0;
    end else if(!SBRWI && i2c_busy) begin
        i2c_ack <= 1;
        i2c_irq <= 1;
        i2c_wakeup <= 1;
        i2c_busy <= 0;
    end else if(!SBSTBI && !SBRWI && !i2c_busy) begin
        i2c_data <= 0;
        i2c_ack <= 0;
        i2c_irq <= 0;
        i2c_wakeup <= 0;
    end
end

always @(posedge SBCLKI) begin
    if(SBSTBI && SBADRI == I2C_SLAVE_INIT_ADDR) begin
        scl <= 0;
        sda <= 0;
    end else if(SBSTBI && SBADRI == i2c_address && SBRWI) begin
        scl <= 0;
        sda <= 0;
    end else if(SBSTBI && SBADRI == i2c_address && !SBRWI) begin
        scl <= 0;
        sda <= 1;
    end else if(!SBSTBI && SBADRI == i2c_address && !SBRWI) begin
        scl <= 1;
        sda <= 1;
    end else if(!SBSTBI && SBADRI == i2c_address && SBRWI) begin
        scl <= 1;
        sda <= 0;
    end else begin
        scl <= 1;
        sda <= 1;
    end
end

endmodule