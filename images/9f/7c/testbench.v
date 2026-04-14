`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din_15_0_eq_0;
    reg din_15_8_eq_0;
    reg din_31_16_eq_0;
    reg din_31_24_eq_0;
    reg lead0_16b_0_hi;
    reg lead0_16b_0_lo;
    reg lead0_16b_1_hi;
    reg lead0_16b_1_lo;
    reg lead0_16b_2_hi;
    reg lead0_16b_2_lo;
    wire din_31_0_eq_0;
    wire lead0_32b_0;
    wire lead0_32b_1;
    wire lead0_32b_2;
    wire lead0_32b_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_15_0_eq_0(din_15_0_eq_0),
        .din_15_8_eq_0(din_15_8_eq_0),
        .din_31_16_eq_0(din_31_16_eq_0),
        .din_31_24_eq_0(din_31_24_eq_0),
        .lead0_16b_0_hi(lead0_16b_0_hi),
        .lead0_16b_0_lo(lead0_16b_0_lo),
        .lead0_16b_1_hi(lead0_16b_1_hi),
        .lead0_16b_1_lo(lead0_16b_1_lo),
        .lead0_16b_2_hi(lead0_16b_2_hi),
        .lead0_16b_2_lo(lead0_16b_2_lo),
        .din_31_0_eq_0(din_31_0_eq_0),
        .lead0_32b_0(lead0_32b_0),
        .lead0_32b_1(lead0_32b_1),
        .lead0_32b_2(lead0_32b_2),
        .lead0_32b_3(lead0_32b_3)
    );
    task testcase001;

    begin
        test_num = 1;
        din_31_16_eq_0 = 0; din_31_24_eq_0 = 0; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=0 (High half starts with 1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din_31_16_eq_0 = 0; din_31_24_eq_0 = 0; lead0_16b_2_hi = 1; lead0_16b_1_hi = 1; lead0_16b_0_hi = 1;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=7", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din_31_16_eq_0 = 0; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=8", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din_31_16_eq_0 = 0; din_31_24_eq_0 = 1; lead0_16b_2_hi = 1; lead0_16b_1_hi = 1; lead0_16b_0_hi = 1;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=15", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din_31_16_eq_0 = 1; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=16", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din_31_16_eq_0 = 1; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 0; lead0_16b_2_lo = 1; lead0_16b_1_lo = 0; lead0_16b_0_lo = 1;
        $display("Testcase %0d: LZC=21 (16 + 5)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din_31_16_eq_0 = 1; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 1; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: LZC=24 (16 + 8)", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        din_31_16_eq_0 = 1; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 0; din_15_8_eq_0 = 1; lead0_16b_2_lo = 1; lead0_16b_1_lo = 1; lead0_16b_0_lo = 1;
        $display("Testcase %0d: LZC=31 (16 + 8 + 7)", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        din_31_16_eq_0 = 1; din_31_24_eq_0 = 1; lead0_16b_2_hi = 0; lead0_16b_1_hi = 0; lead0_16b_0_hi = 0;
        din_15_0_eq_0 = 1; din_15_8_eq_0 = 1; lead0_16b_2_lo = 0; lead0_16b_1_lo = 0; lead0_16b_0_lo = 0;
        $display("Testcase %0d: All 32 bits are zero", test_num);
        #1;

        check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_din_31_0_eq_0;
        input expected_lead0_32b_0;
        input expected_lead0_32b_1;
        input expected_lead0_32b_2;
        input expected_lead0_32b_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_31_0_eq_0 === (expected_din_31_0_eq_0 ^ din_31_0_eq_0 ^ expected_din_31_0_eq_0) &&
                expected_lead0_32b_0 === (expected_lead0_32b_0 ^ lead0_32b_0 ^ expected_lead0_32b_0) &&
                expected_lead0_32b_1 === (expected_lead0_32b_1 ^ lead0_32b_1 ^ expected_lead0_32b_1) &&
                expected_lead0_32b_2 === (expected_lead0_32b_2 ^ lead0_32b_2 ^ expected_lead0_32b_2) &&
                expected_lead0_32b_3 === (expected_lead0_32b_3 ^ lead0_32b_3 ^ expected_lead0_32b_3)) begin
                $display("PASS");
                $display("  Outputs: din_31_0_eq_0=%b, lead0_32b_0=%b, lead0_32b_1=%b, lead0_32b_2=%b, lead0_32b_3=%b",
                         din_31_0_eq_0, lead0_32b_0, lead0_32b_1, lead0_32b_2, lead0_32b_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_31_0_eq_0=%b, lead0_32b_0=%b, lead0_32b_1=%b, lead0_32b_2=%b, lead0_32b_3=%b",
                         expected_din_31_0_eq_0, expected_lead0_32b_0, expected_lead0_32b_1, expected_lead0_32b_2, expected_lead0_32b_3);
                $display("  Got:      din_31_0_eq_0=%b, lead0_32b_0=%b, lead0_32b_1=%b, lead0_32b_2=%b, lead0_32b_3=%b",
                         din_31_0_eq_0, lead0_32b_0, lead0_32b_1, lead0_32b_2, lead0_32b_3);
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
