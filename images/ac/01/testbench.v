`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg D;
    wire Q;
    wire nQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .nQ(nQ)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Transparent Mode - Input 0", test_num);

        CLK = 1; D = 1; #10;

        D = 0; #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transparent Mode - Input 1", test_num);

        CLK = 1; D = 0; #10;

        D = 1; #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Holding Value 1 (CLK High -> Low)", test_num);

        CLK = 1; D = 1; #10;

        CLK = 0; #10;

        D = 0; #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Holding Value 0 (CLK High -> Low)", test_num);

        CLK = 1; D = 0; #10;

        CLK = 0; #10;

        D = 1; #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data update on CLK High level", test_num);

        CLK = 0; D = 0; #10;

        CLK = 1; #10;

        D = 1; #5;
        D = 0; #5;
        D = 1; #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Stability when CLK is Low", test_num);

        CLK = 1; D = 1; #10;

        CLK = 0; #10;

        D = 0; #5;
        D = 1; #5;
        D = 0; #5;
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
        input expected_Q;
        input expected_nQ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_nQ === (expected_nQ ^ nQ ^ expected_nQ)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, nQ=%b",
                         Q, nQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, nQ=%b",
                         expected_Q, expected_nQ);
                $display("  Got:      Q=%b, nQ=%b",
                         Q, nQ);
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
