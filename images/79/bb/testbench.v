`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg q;
    reg [3:0] x;
    wire X3;
    wire X4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q(q),
        .x(x),
        .X3(X3),
        .X4(X4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State T (0001), q=0 -> Next: U (0010)", test_num);
        q = 1'b0; x = 4'b0001;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State T (0001), q=1 -> Next: V (0100)", test_num);
        q = 1'b1; x = 4'b0001;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State U (0010), q=0 -> Next: T (0001)", test_num);
        q = 1'b0; x = 4'b0010;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State U (0010), q=1 -> Next: W (1000)", test_num);
        q = 1'b1; x = 4'b0010;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State V (0100), q=0 -> Next: W (1000)", test_num);
        q = 1'b0; x = 4'b0100;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State V (0100), q=1 -> Next: T (0001)", test_num);
        q = 1'b1; x = 4'b0100;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State W (1000), q=0 -> Next: U (0010)", test_num);
        q = 1'b0; x = 4'b1000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: State W (1000), q=1 -> Next: V (0100)", test_num);
        q = 1'b1; x = 4'b1000;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero", test_num);
        q = 1'b0; x = 4'b0000;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_X3;
        input expected_X4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X3 === (expected_X3 ^ X3 ^ expected_X3) &&
                expected_X4 === (expected_X4 ^ X4 ^ expected_X4)) begin
                $display("PASS");
                $display("  Outputs: X3=%b, X4=%b",
                         X3, X4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X3=%b, X4=%b",
                         expected_X3, expected_X4);
                $display("  Got:      X3=%b, X4=%b",
                         X3, X4);
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
