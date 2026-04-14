`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg In;
    reg S;
    wire Out0;
    wire Out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .S(S),
        .Out0(Out0),
        .Out1(Out1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: S=0, In=0", test_num);
        S = 1'b0;
        In = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: S=0, In=1", test_num);
        S = 1'b0;
        In = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: S=1, In=0", test_num);
        S = 1'b1;
        In = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: S=1, In=1", test_num);
        S = 1'b1;
        In = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_Out0;
        input expected_Out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out0 === (expected_Out0 ^ Out0 ^ expected_Out0) &&
                expected_Out1 === (expected_Out1 ^ Out1 ^ expected_Out1)) begin
                $display("PASS");
                $display("  Outputs: Out0=%b, Out1=%b",
                         Out0, Out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out0=%b, Out1=%b",
                         expected_Out0, expected_Out1);
                $display("  Got:      Out0=%b, Out1=%b",
                         Out0, Out1);
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
