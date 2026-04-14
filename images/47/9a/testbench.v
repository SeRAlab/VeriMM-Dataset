`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg AregFPMSBP1;
    reg [1:0] AregLSBDB;
    reg [1:0] AregLSBSN;
    reg [1:0] AregSticky;
    reg SNnotDB;
    wire StickyForSR1;
    wire TrueIEEEAregLSB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AregFPMSBP1(AregFPMSBP1),
        .AregLSBDB(AregLSBDB),
        .AregLSBSN(AregLSBSN),
        .AregSticky(AregSticky),
        .SNnotDB(SNnotDB),
        .StickyForSR1(StickyForSR1),
        .TrueIEEEAregLSB(TrueIEEEAregLSB)
    );
    task testcase001;

    begin
        test_num = 1;
        SNnotDB = 1'b1;
        AregFPMSBP1 = 1'b0;
        AregLSBSN = 2'b10;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Single, No Overflow, LSB 0, Sticky 0", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        SNnotDB = 1'b1;
        AregFPMSBP1 = 1'b0;
        AregLSBSN = 2'b01;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Single, No Overflow, LSB 1, Sticky 0", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        SNnotDB = 1'b1;
        AregFPMSBP1 = 1'b0;
        AregLSBSN = 2'b00;
        AregSticky = 2'b10;
        #1;
        $display("Test %0d: Single, No Overflow, Sticky input active", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        SNnotDB = 1'b1;
        AregFPMSBP1 = 1'b1;
        AregLSBSN = 2'b10;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Single, Overflow, bit[1] is LSB, bit[0] is Sticky", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        SNnotDB = 1'b1;
        AregFPMSBP1 = 1'b1;
        AregLSBSN = 2'b01;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Single, Overflow, bit[0] makes result Sticky", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        SNnotDB = 1'b0;
        AregFPMSBP1 = 1'b0;
        AregLSBDB = 2'b01;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Double, No Overflow, LSB 1", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        SNnotDB = 1'b0;
        AregFPMSBP1 = 1'b1;
        AregLSBDB = 2'b11;
        AregSticky = 2'b00;
        #1;
        $display("Test %0d: Double, Overflow, both bits set", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        SNnotDB = 1'b0;
        AregFPMSBP1 = 1'b1;
        AregLSBDB = 2'b00;
        AregSticky = 2'b01;
        #1;
        $display("Test %0d: Double, Overflow, check existing Sticky carry-through", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_StickyForSR1;
        input expected_TrueIEEEAregLSB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_StickyForSR1 === (expected_StickyForSR1 ^ StickyForSR1 ^ expected_StickyForSR1) &&
                expected_TrueIEEEAregLSB === (expected_TrueIEEEAregLSB ^ TrueIEEEAregLSB ^ expected_TrueIEEEAregLSB)) begin
                $display("PASS");
                $display("  Outputs: StickyForSR1=%b, TrueIEEEAregLSB=%b",
                         StickyForSR1, TrueIEEEAregLSB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: StickyForSR1=%b, TrueIEEEAregLSB=%b",
                         expected_StickyForSR1, expected_TrueIEEEAregLSB);
                $display("  Got:      StickyForSR1=%b, TrueIEEEAregLSB=%b",
                         StickyForSR1, TrueIEEEAregLSB);
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
