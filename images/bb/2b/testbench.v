`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg clk;
    wire [3:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: 0 * 0");
            reset_dut();
            a = 2'd0;
            b = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 1 * 1");
            reset_dut();
            a = 2'd1;
            b = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 3 * 3");
            reset_dut();
            a = 2'd3;
            b = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 2 * 3");
            reset_dut();
            a = 2'd2;
            b = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 3 * 0");
            reset_dut();
            a = 2'd3;
            b = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: 1 * 2");
            reset_dut();
            a = 2'd1;
            b = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: 2 * 2");
            reset_dut();
            a = 2'd2;
            b = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: 3 * 1");
            reset_dut();
            a = 2'd3;
            b = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
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
        input [3:0] expected_c;
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
        $dumpvars(0,a, b, clk, c);
    end

endmodule
