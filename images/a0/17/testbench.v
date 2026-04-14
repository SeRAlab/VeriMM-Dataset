`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg OUT;
    wire vystup2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OUT(OUT),
        .vystup2(vystup2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input OUT = 0", test_num);
        OUT = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input OUT = 1", test_num);
        OUT = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transition 1 to 0", test_num);
        OUT = 1'b1;
        #5;
        OUT = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transition 0 to 1", test_num);
        OUT = 1'b0;
        #5;
        OUT = 1'b1;

        #1;


        check_outputs(1'b1);
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
        input expected_vystup2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vystup2 === (expected_vystup2 ^ vystup2 ^ expected_vystup2)) begin
                $display("PASS");
                $display("  Outputs: vystup2=%b",
                         vystup2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vystup2=%b",
                         expected_vystup2);
                $display("  Got:      vystup2=%b",
                         vystup2);
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
