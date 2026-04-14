`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;



            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Positive (3 * 2)", test_num);
            reset_dut();
            A = 4'sd3;
            B = 4'sd2;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Negative (3 * -2)", test_num);
            reset_dut();
            A = 4'sd3;
            B = -4'sd2;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Positive (-3 * 2)", test_num);
            reset_dut();
            A = -4'sd3;
            B = 4'sd2;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Negative (-4 * -3)", test_num);
            reset_dut();
            A = -4'sd4;
            B = -4'sd3;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Multiply (0 * -5)", test_num);
            reset_dut();
            A = 4'sd0;
            B = -4'sd5;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Positive (7 * 7)", test_num);
            reset_dut();
            A = 4'sd7;
            B = 4'sd7;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Negative * Max Positive (-8 * 7)", test_num);
            reset_dut();
            A = -4'sd8;
            B = 4'sd7;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Negative * Min Negative (-8 * -8)", test_num);
            reset_dut();
            A = -4'sd8;
            B = -4'sd8;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by One (5 * 1)", test_num);
            reset_dut();
            A = 4'sd5;
            B = 4'sd1;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by Minus One (-7 * -1)", test_num);
            reset_dut();
            A = -4'sd7;
            B = -4'sd1;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'sd7);
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
        input [7:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, P);
    end

endmodule
