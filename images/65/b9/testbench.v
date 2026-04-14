`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire [1:0] X;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .X(X),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 0; B = 0; C = 0; D = 0;
        $display("Testcase %0d: All inputs low", test_num);
        #1;

        check_outputs(2'b11, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 0; B = 0; C = 0; D = 1;
        $display("Testcase %0d: Input D active (Highest Priority)", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 0; B = 0; C = 1; D = 0;
        $display("Testcase %0d: Input C active", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 0; B = 1; C = 0; D = 0;
        $display("Testcase %0d: Input B active", test_num);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 1; B = 0; C = 0; D = 0;
        $display("Testcase %0d: Input A active (Lowest Priority)", test_num);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 0; B = 0; C = 1; D = 1;
        $display("Testcase %0d: Inputs D and C active (D takes priority)", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 0; B = 1; C = 1; D = 0;
        $display("Testcase %0d: Inputs C and B active (C takes priority)", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 1; B = 1; C = 0; D = 0;
        $display("Testcase %0d: Inputs B and A active (B takes priority)", test_num);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 1; B = 0; C = 0; D = 1;
        $display("Testcase %0d: Inputs D and A active (D takes priority)", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 1; B = 1; C = 1; D = 1;
        $display("Testcase %0d: All inputs active (D takes priority)", test_num);
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 1; B = 0; C = 1; D = 0;
        $display("Testcase %0d: Inputs C and A active (C takes priority)", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
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
        testcase011();
        
        
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
        input [1:0] expected_X;
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: X=%h, Y=%b",
                         X, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h, Y=%b",
                         expected_X, expected_Y);
                $display("  Got:      X=%h, Y=%b",
                         X, Y);
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
