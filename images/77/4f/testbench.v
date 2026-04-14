`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg VGND;
    reg VPWR;
    wire PWROK;
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
        .VGND(VGND),
        .VPWR(VPWR),
        .PWROK(PWROK),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power off (VPWR=0, VGND=0)", test_num);
            VPWR = 0;
            VGND = 0;
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Invalid power (VPWR=1, VGND=1)", test_num);
            VPWR = 1;
            VGND = 1;
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Power Good, All Inputs 1", test_num);
            VPWR = 1;
            VGND = 0;
            A = 1; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Power Good, Input A=0", test_num);
            VPWR = 1;
            VGND = 0;
            A = 0; B = 1; C = 1; D = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Power Good, Input B=0", test_num);
            VPWR = 1;
            VGND = 0;
            A = 1; B = 0; C = 1; D = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Power Good, Input C=0", test_num);
            VPWR = 1;
            VGND = 0;
            A = 1; B = 1; C = 0; D = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Power Good, Input D=0", test_num);
            VPWR = 1;
            VGND = 0;
            A = 1; B = 1; C = 1; D = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Power Good, All Inputs 0", test_num);
            VPWR = 1;
            VGND = 0;
            A = 0; B = 0; C = 0; D = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Power-up Transition", test_num);

            VPWR = 0; VGND = 0; A = 1; B = 1; C = 1; D = 1;
            #5;

            VPWR = 1; VGND = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Power-down Transition", test_num);

            VPWR = 1; VGND = 0; A = 1; B = 1; C = 1; D = 1;
            #5;

            VPWR = 0;
            #1;

            check_outputs(0, 0);
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
        input expected_PWROK;
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PWROK === (expected_PWROK ^ PWROK ^ expected_PWROK) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: PWROK=%b, Y=%b",
                         PWROK, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWROK=%b, Y=%b",
                         expected_PWROK, expected_Y);
                $display("  Got:      PWROK=%b, Y=%b",
                         PWROK, Y);
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
