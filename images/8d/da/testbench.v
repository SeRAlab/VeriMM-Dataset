`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .D(D),
        .R(R),
        .S(S),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            R = 1;
            S = 0;
            D = 0;
            #12;
            R = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            R = 1;
            #2;
            #1;

            check_outputs(0);
            R = 0;
            #8;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            S = 1;
            #2;
            #1;

            check_outputs(1);
            S = 0;
            #8;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            D = 1;
            @(posedge C);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            D = 1;
            @(posedge C);
            #2;

            D = 0;
            @(posedge C);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            S = 1;
            R = 1;
            #2;

            #1;


            check_outputs(0);
            R = 0;
            S = 0;
            #8;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            D = 0;
            S = 1;

            @(posedge C);
            #2;
            #1;

            check_outputs(1);
            S = 0;
            #8;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            D = 1;
            @(posedge C);
            #2;
            D = 0;
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            R = 1;
            #2;
            R = 0;
            #2;
            D = 1;
            @(posedge C);
            #2;
            #1;

            check_outputs(1);
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
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,C, D, R, S, Q);
    end

endmodule
