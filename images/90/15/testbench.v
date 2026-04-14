`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clock;
    reg reset;
    wire Q;
    wire Qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .J(J),
        .K(K),
        .clock(clock),
        .reset(reset),
        .Q(Q),
        .Qbar(Qbar)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            J = 0;
            K = 0;
            cycle();
            reset = 0;
            cycle();
        end
        endtask
    task cycle;

        begin
            @(posedge clock);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Set Operation (J=1, K=0)", test_num);
            reset_dut();
            J = 1; K = 0;
            cycle();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Clear Operation (J=0, K=1)", test_num);
            reset_dut();

            J = 1; K = 0;
            cycle();

            J = 0; K = 1;
            cycle();
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold Operation (J=0, K=0)", test_num);
            reset_dut();
            J = 1; K = 0;
            cycle();
            J = 0; K = 0;
            cycle();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle Operation (0 to 1)", test_num);
            reset_dut();
            J = 1; K = 1;
            cycle();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Double Toggle Operation (0 -> 1 -> 0)", test_num);
            reset_dut();
            J = 1; K = 1;
            cycle();
            cycle();
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Complex Sequence", test_num);
            reset_dut();
            J = 1; K = 0; cycle();
            J = 0; K = 0; cycle();
            J = 0; K = 1; cycle();
            J = 0; K = 0; cycle();
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
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_Qbar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qbar === (expected_Qbar ^ Qbar ^ expected_Qbar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qbar=%b",
                         Q, Qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qbar=%b",
                         expected_Q, expected_Qbar);
                $display("  Got:      Q=%b, Qbar=%b",
                         Q, Qbar);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,J, K, clock, reset, Q, Qbar);
    end

endmodule
