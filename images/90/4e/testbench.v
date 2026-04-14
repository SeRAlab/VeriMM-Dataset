`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1_N;
    reg A2_N;
    reg B1;
    reg B2;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1_N(A1_N),
        .A2_N(A2_N),
        .B1(B1),
        .B2(B2),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A1_N = 0; A2_N = 0; B1 = 0; B2 = 0;
        $display("Testcase %0d: All inputs zero", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A1_N = 1; A2_N = 1; B1 = 0; B2 = 0;
        $display("Testcase %0d: A inputs TRUE, B inputs FALSE", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A1_N = 0; A2_N = 0; B1 = 1; B2 = 1;
        $display("Testcase %0d: B inputs TRUE, A inputs FALSE", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A1_N = 1; A2_N = 1; B1 = 1; B2 = 1;
        $display("Testcase %0d: All inputs TRUE", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A1_N = 1; A2_N = 0; B1 = 1; B2 = 0;
        $display("Testcase %0d: Mixed inputs (incomplete pairs)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A1_N = 0; A2_N = 1; B1 = 0; B2 = 1;
        $display("Testcase %0d: Alternating inputs", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A1_N = 1; A2_N = 0; B1 = 0; B2 = 0;
        $display("Testcase %0d: Only A1_N TRUE", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A1_N = 0; A2_N = 0; B1 = 1; B2 = 0;
        $display("Testcase %0d: Only B1 TRUE", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A1_N = 1; A2_N = 1; B1 = 0; B2 = 1;
        $display("Testcase %0d: A inputs TRUE, B mixed", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A1_N = 0; A2_N = 1; B1 = 1; B2 = 1;
        $display("Testcase %0d: B inputs TRUE, A mixed", test_num);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
