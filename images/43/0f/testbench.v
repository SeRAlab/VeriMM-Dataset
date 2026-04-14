`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DOA;
    reg DOB;
    reg DOC;
    reg DOD;
    wire DOA_OUT;
    wire DOB_OUT;
    wire DOC_OUT;
    wire DOD_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DOA(DOA),
        .DOB(DOB),
        .DOC(DOC),
        .DOD(DOD),
        .DOA_OUT(DOA_OUT),
        .DOB_OUT(DOB_OUT),
        .DOC_OUT(DOC_OUT),
        .DOD_OUT(DOD_OUT)
    );
    task testcase001;

    begin
        $display("Testcase 001: All inputs LOW");
        DOA = 1'b0; DOB = 1'b0; DOC = 1'b0; DOD = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All inputs HIGH");
        DOA = 1'b1; DOB = 1'b1; DOC = 1'b1; DOD = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Walking 1 - DOA only");
        DOA = 1'b1; DOB = 1'b0; DOC = 1'b0; DOD = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Walking 1 - DOB only");
        DOA = 1'b0; DOB = 1'b1; DOC = 1'b0; DOD = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Walking 1 - DOC only");
        DOA = 1'b0; DOB = 1'b0; DOC = 1'b1; DOD = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Walking 1 - DOD only");
        DOA = 1'b0; DOB = 1'b0; DOC = 1'b0; DOD = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Alternating pattern 1010");
        DOA = 1'b1; DOB = 1'b0; DOC = 1'b1; DOD = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Alternating pattern 0101");
        DOA = 1'b0; DOB = 1'b1; DOC = 1'b0; DOD = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Pattern 1100");
        DOA = 1'b1; DOB = 1'b1; DOC = 1'b0; DOD = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Pattern 0011");
        DOA = 1'b0; DOB = 1'b0; DOC = 1'b1; DOD = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        testcase010();
        
        
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
        input expected_DOA_OUT;
        input expected_DOB_OUT;
        input expected_DOC_OUT;
        input expected_DOD_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOA_OUT === (expected_DOA_OUT ^ DOA_OUT ^ expected_DOA_OUT) &&
                expected_DOB_OUT === (expected_DOB_OUT ^ DOB_OUT ^ expected_DOB_OUT) &&
                expected_DOC_OUT === (expected_DOC_OUT ^ DOC_OUT ^ expected_DOC_OUT) &&
                expected_DOD_OUT === (expected_DOD_OUT ^ DOD_OUT ^ expected_DOD_OUT)) begin
                $display("PASS");
                $display("  Outputs: DOA_OUT=%b, DOB_OUT=%b, DOC_OUT=%b, DOD_OUT=%b",
                         DOA_OUT, DOB_OUT, DOC_OUT, DOD_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOA_OUT=%b, DOB_OUT=%b, DOC_OUT=%b, DOD_OUT=%b",
                         expected_DOA_OUT, expected_DOB_OUT, expected_DOC_OUT, expected_DOD_OUT);
                $display("  Got:      DOA_OUT=%b, DOB_OUT=%b, DOC_OUT=%b, DOD_OUT=%b",
                         DOA_OUT, DOB_OUT, DOC_OUT, DOD_OUT);
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
