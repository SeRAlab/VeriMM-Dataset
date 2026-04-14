`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg iA;
    reg iB;
    wire oCARRY;
    wire oSUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iA(iA),
        .iB(iB),
        .oCARRY(oCARRY),
        .oSUM(oSUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: iA=0, iB=0", test_num);
        iA = 1'b0;
        iB = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: iA=0, iB=1", test_num);
        iA = 1'b0;
        iB = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: iA=1, iB=0", test_num);
        iA = 1'b1;
        iB = 1'b0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: iA=1, iB=1", test_num);
        iA = 1'b1;
        iB = 1'b1;
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
        input expected_oCARRY;
        input expected_oSUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oCARRY === (expected_oCARRY ^ oCARRY ^ expected_oCARRY) &&
                expected_oSUM === (expected_oSUM ^ oSUM ^ expected_oSUM)) begin
                $display("PASS");
                $display("  Outputs: oCARRY=%b, oSUM=%b",
                         oCARRY, oSUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCARRY=%b, oSUM=%b",
                         expected_oCARRY, expected_oSUM);
                $display("  Got:      oCARRY=%b, oSUM=%b",
                         oCARRY, oSUM);
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
