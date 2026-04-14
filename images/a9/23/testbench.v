`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg D;
    reg GATE_N;
    reg RESET_B;
    reg VGND;
    reg VPWR;
    wire Q;
    wire Q_N;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .D(D),
        .GATE_N(GATE_N),
        .RESET_B(RESET_B),
        .VGND(VGND),
        .VPWR(VPWR),
        .Q(Q),
        .Q_N(Q_N),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;

            RESET_B = 0; A = 0; B = 0; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;

            A = 1; B = 1; GATE_N = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RESET_B = 0; A = 0; B = 0; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;
            A = 0; B = 1; GATE_N = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RESET_B = 0; A = 0; B = 0; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;

            A = 1; B = 1; GATE_N = 0;
            #10;

            GATE_N = 1;
            #10;

            A = 0; B = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RESET_B = 0; A = 0; B = 0; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;

            A = 1; B = 1; GATE_N = 0;
            #10;

            RESET_B = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RESET_B = 0; A = 1; B = 1; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;
            A = 0; B = 0; GATE_N = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            RESET_B = 0; A = 1; B = 1; GATE_N = 1; D = 0; VPWR = 1; VGND = 0;
            #10;
            RESET_B = 1;
            #10;
            A = 1; B = 0; GATE_N = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_Q_N;
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b, Y=%b",
                         Q, Q_N, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b, Y=%b",
                         expected_Q, expected_Q_N, expected_Y);
                $display("  Got:      Q=%b, Q_N=%b, Y=%b",
                         Q, Q_N, Y);
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
