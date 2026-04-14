`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg clk;
    reg reset;
    wire error;
    wire [3:0] sqrt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .reset(reset),
        .error(error),
        .sqrt(sqrt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            @(posedge clk);
            #1;
            reset = 0;

            repeat(2) @(posedge clk);
        end
        endtask
    task run_calc;

        input signed [3:0] val;
        begin
            a = val;

            repeat(10) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Input a = 0", test_num);
            run_calc(4'sd0);
            #1;

            check_outputs(1'b0, 4'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Input a = 1", test_num);
            run_calc(4'sd1);
            #1;

            check_outputs(1'b0, 4'sd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Input a = 4", test_num);
            run_calc(4'sd4);
            #1;

            check_outputs(1'b0, 4'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Input a = 7", test_num);
            run_calc(4'sd7);
            #1;

            check_outputs(1'b0, 4'sd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Input a = -1", test_num);
            run_calc(-4'sd1);
            #1;

            check_outputs(1'b1, sqrt);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: Input a = -8", test_num);
            run_calc(-4'sd8);
            #1;

            check_outputs(1'b1, sqrt);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test Case %0d: Input a = 2", test_num);
            run_calc(4'sd2);
            #1;

            check_outputs(1'b0, 4'sd1);
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
        input expected_error;
        input [3:0] expected_sqrt;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_sqrt === (expected_sqrt ^ sqrt ^ expected_sqrt)) begin
                $display("PASS");
                $display("  Outputs: error=%b, sqrt=%h",
                         error, sqrt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, sqrt=%h",
                         expected_error, expected_sqrt);
                $display("  Got:      error=%b, sqrt=%h",
                         error, sqrt);
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
        $dumpvars(0,a, clk, reset, error, sqrt);
    end

endmodule
