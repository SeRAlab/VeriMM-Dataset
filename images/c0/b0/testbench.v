`timescale 1ns/1ps

module NANOCODE_DECODER_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] NANO_ROM_IN;
    wire AD_o;
    wire CE_o;
    wire CLEAR_MICRO_o;
    wire CP_o;
    wire CS_o;
    wire EA_o;
    wire EI_o;
    wire EP_o;
    wire EU_o;
    wire INC_MICRO_o;
    wire LA_o;
    wire LB_o;
    wire LI_o;
    wire LM_o;
    wire LOAD_MICRO_o;
    wire LO_o;
    wire SU_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NANOCODE_DECODER dut (
        .NANO_ROM_IN(NANO_ROM_IN),
        .AD_o(AD_o),
        .CE_o(CE_o),
        .CLEAR_MICRO_o(CLEAR_MICRO_o),
        .CP_o(CP_o),
        .CS_o(CS_o),
        .EA_o(EA_o),
        .EI_o(EI_o),
        .EP_o(EP_o),
        .EU_o(EU_o),
        .INC_MICRO_o(INC_MICRO_o),
        .LA_o(LA_o),
        .LB_o(LB_o),
        .LI_o(LI_o),
        .LM_o(LM_o),
        .LOAD_MICRO_o(LOAD_MICRO_o),
        .LO_o(LO_o),
        .SU_o(SU_o)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NANOCODE_DECODER Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_AD_o;
        input expected_CE_o;
        input expected_CLEAR_MICRO_o;
        input expected_CP_o;
        input expected_CS_o;
        input expected_EA_o;
        input expected_EI_o;
        input expected_EP_o;
        input expected_EU_o;
        input expected_INC_MICRO_o;
        input expected_LA_o;
        input expected_LB_o;
        input expected_LI_o;
        input expected_LM_o;
        input expected_LOAD_MICRO_o;
        input expected_LO_o;
        input expected_SU_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AD_o === (expected_AD_o ^ AD_o ^ expected_AD_o) &&
                expected_CE_o === (expected_CE_o ^ CE_o ^ expected_CE_o) &&
                expected_CLEAR_MICRO_o === (expected_CLEAR_MICRO_o ^ CLEAR_MICRO_o ^ expected_CLEAR_MICRO_o) &&
                expected_CP_o === (expected_CP_o ^ CP_o ^ expected_CP_o) &&
                expected_CS_o === (expected_CS_o ^ CS_o ^ expected_CS_o) &&
                expected_EA_o === (expected_EA_o ^ EA_o ^ expected_EA_o) &&
                expected_EI_o === (expected_EI_o ^ EI_o ^ expected_EI_o) &&
                expected_EP_o === (expected_EP_o ^ EP_o ^ expected_EP_o) &&
                expected_EU_o === (expected_EU_o ^ EU_o ^ expected_EU_o) &&
                expected_INC_MICRO_o === (expected_INC_MICRO_o ^ INC_MICRO_o ^ expected_INC_MICRO_o) &&
                expected_LA_o === (expected_LA_o ^ LA_o ^ expected_LA_o) &&
                expected_LB_o === (expected_LB_o ^ LB_o ^ expected_LB_o) &&
                expected_LI_o === (expected_LI_o ^ LI_o ^ expected_LI_o) &&
                expected_LM_o === (expected_LM_o ^ LM_o ^ expected_LM_o) &&
                expected_LOAD_MICRO_o === (expected_LOAD_MICRO_o ^ LOAD_MICRO_o ^ expected_LOAD_MICRO_o) &&
                expected_LO_o === (expected_LO_o ^ LO_o ^ expected_LO_o) &&
                expected_SU_o === (expected_SU_o ^ SU_o ^ expected_SU_o)) begin
                $display("PASS");
                $display("  Outputs: AD_o=%b, CE_o=%b, CLEAR_MICRO_o=%b, CP_o=%b, CS_o=%b, EA_o=%b, EI_o=%b, EP_o=%b, EU_o=%b, INC_MICRO_o=%b, LA_o=%b, LB_o=%b, LI_o=%b, LM_o=%b, LOAD_MICRO_o=%b, LO_o=%b, SU_o=%b",
                         AD_o, CE_o, CLEAR_MICRO_o, CP_o, CS_o, EA_o, EI_o, EP_o, EU_o, INC_MICRO_o, LA_o, LB_o, LI_o, LM_o, LOAD_MICRO_o, LO_o, SU_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AD_o=%b, CE_o=%b, CLEAR_MICRO_o=%b, CP_o=%b, CS_o=%b, EA_o=%b, EI_o=%b, EP_o=%b, EU_o=%b, INC_MICRO_o=%b, LA_o=%b, LB_o=%b, LI_o=%b, LM_o=%b, LOAD_MICRO_o=%b, LO_o=%b, SU_o=%b",
                         expected_AD_o, expected_CE_o, expected_CLEAR_MICRO_o, expected_CP_o, expected_CS_o, expected_EA_o, expected_EI_o, expected_EP_o, expected_EU_o, expected_INC_MICRO_o, expected_LA_o, expected_LB_o, expected_LI_o, expected_LM_o, expected_LOAD_MICRO_o, expected_LO_o, expected_SU_o);
                $display("  Got:      AD_o=%b, CE_o=%b, CLEAR_MICRO_o=%b, CP_o=%b, CS_o=%b, EA_o=%b, EI_o=%b, EP_o=%b, EU_o=%b, INC_MICRO_o=%b, LA_o=%b, LB_o=%b, LI_o=%b, LM_o=%b, LOAD_MICRO_o=%b, LO_o=%b, SU_o=%b",
                         AD_o, CE_o, CLEAR_MICRO_o, CP_o, CS_o, EA_o, EI_o, EP_o, EU_o, INC_MICRO_o, LA_o, LB_o, LI_o, LM_o, LOAD_MICRO_o, LO_o, SU_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
