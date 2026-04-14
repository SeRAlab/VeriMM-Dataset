`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    wire [7:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_cycles;

        input integer cycles;
        begin
            repeat(cycles) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 * 2", test_num);
            reset_dut();
            a = 4'sd3;
            b = 4'sd2;
            wait_cycles(10);
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 * -2", test_num);
            reset_dut();
            a = 4'sd3;
            b = -4'sd2;
            wait_cycles(10);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -3 * 2", test_num);
            reset_dut();
            a = -4'sd3;
            b = 4'sd2;
            wait_cycles(10);
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -3 * -4", test_num);
            reset_dut();
            a = -4'sd3;
            b = -4'sd4;
            wait_cycles(10);
            #1;

            check_outputs(8'sd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 * -5", test_num);
            reset_dut();
            a = 4'sd0;
            b = -4'sd5;
            wait_cycles(10);
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 7 * 7", test_num);
            reset_dut();
            a = 4'sd7;
            b = 4'sd7;
            wait_cycles(10);
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -8 * 7", test_num);
            reset_dut();
            a = -4'sd8;
            b = 4'sd7;
            wait_cycles(10);
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -8 * -8", test_num);
            reset_dut();
            a = -4'sd8;
            b = -4'sd8;
            wait_cycles(10);
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1 * -1", test_num);
            reset_dut();
            a = -4'sd1;
            b = -4'sd1;
            wait_cycles(10);
            #1;

            check_outputs(8'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -8 * 1", test_num);
            reset_dut();
            a = -4'sd8;
            b = 4'sd1;
            wait_cycles(10);
            #1;

            check_outputs(-8'sd8);
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
        input [7:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, reset, c);
    end

endmodule
