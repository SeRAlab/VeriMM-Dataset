module top_module(
	input nReset,
	input clock,
	input [9:0] adc_databus,
	input testModeFlag,
	
	// Outputs
	output [9:0] dataOut
);// Register to store test and ADC data values
reg [9:0] adcData;
reg [9:0] testData;
wire [9:0] adc_databusRead;

// If we are in test-mode use test data,
// otherwise use the actual ADC data
assign dataOut = testModeFlag ? testData : adcData;

// Read the ADC data and generate the test data on the
// negative edge of the clock
//
// Note: The test data is a repeating pattern of incrementing
// values from 0 to 1023.
always @ (posedge clock, negedge nReset) begin
	if (!nReset) begin
		adcData <= 10'd0;
		testData <= 10'd0;
	end else begin
		// Read the ADC data
		adcData <= adc_databus;
		
		// Test mode data generation
		testData <= testData + 10'd1;
		if (testData >= 10'd1023) begin
			testData <= 10'd0;
		end
	end
end

endmodule