`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] a;
    reg [5:0] b;
    reg clk;
    reg set;
    wire [11:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .set(set),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            set = 1;
            a = 6'sd0;
            b = 6'sd0;
            @(posedge clk);
            #1;
            set = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(12'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive Mul-Add (5 * 4 = 20)", test_num);
            reset_dut();
            a = 6'sd5;
            b = 6'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Mul-Add (-6 * 3 = -18)", test_num);
            reset_dut();
            a = -6'sd6;
            b = 6'sd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-12'sd18);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Double Negative Mul-Add (-4 * -7 = 28)", test_num);
            reset_dut();
            a = -6'sd4;
            b = -6'sd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd28);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential Accumulation (2*3 + 4*5 = 26)", test_num);
            reset_dut();

            a = 6'sd2;
            b = 6'sd3;
            @(posedge clk);
            #1;

            a = 6'sd4;
            b = 6'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd26);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Balanced Sum (-10*2 + 5*4 = 0)", test_num);
            reset_dut();
            a = -6'sd10;
            b = 6'sd2;
            @(posedge clk);
            #1;
            a = 6'sd5;
            b = 6'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Max Inputs (31 * -32 = -992)", test_num);
            reset_dut();
            a = 6'sd31;
            b = -6'sd32;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-12'sd992);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Zero Operand (0 * 31 = 0)", test_num);
            reset_dut();
            a = 6'sd0;
            b = 6'sd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            a = 6'sd10;
            b = 6'sd10;
            @(posedge clk);
            #1;
            set = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: 12-bit Signed Wrap-around", test_num);
            reset_dut();
            a = -6'sd32;
            b = -6'sd32;
            @(posedge clk);
            #1;
            a = -6'sd32;
            b = -6'sd32;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-12'sd2048);
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
        input [11:0] expected_c;
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
        $dumpvars(0,a, b, clk, set, c);
    end

endmodule
