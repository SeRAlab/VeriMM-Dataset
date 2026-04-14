`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in_A;
    reg load;
    reg shift;
    wire [30:0] s_A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_A(in_A),
        .load(load),
        .shift(shift),
        .s_A(s_A)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            in_A = 16'h0;
            shift = 0;
            @(negedge clk);
            load = 0;
            shift = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test %0d: Basic Load...", test_num);

            in_A = 16'hA5A5;
            load = 1;
            shift = 0;
            @(negedge clk);
            load = 0;

            #1;
            #1;

            check_outputs(31'h0000A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test %0d: Load and Single Shift...", test_num);

            in_A = 16'h0001;
            load = 1;
            @(negedge clk);

            load = 0;
            shift = 1;
            @(negedge clk);
            shift = 0;

            #1;
            #1;

            check_outputs(31'h00000002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test %0d: Shift across boundary (16 shifts)...", test_num);

            in_A = 16'h0001;
            load = 1;
            @(negedge clk);

            load = 0;
            shift = 1;
            repeat(16) @(negedge clk);
            shift = 0;

            #1;
            #1;

            check_outputs(31'h00010000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test %0d: Shift to MSB (30 shifts)...", test_num);

            in_A = 16'h0001;
            load = 1;
            @(negedge clk);

            load = 0;
            shift = 1;
            repeat(30) @(negedge clk);
            shift = 0;

            #1;
            #1;

            check_outputs(31'h40000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Test %0d: Intermittent shifting...", test_num);

            in_A = 16'h5555;
            load = 1;
            @(negedge clk);

            load = 0;
            shift = 1;
            @(negedge clk);
            @(negedge clk);

            shift = 0;
            @(negedge clk);

            shift = 1;
            @(negedge clk);
            shift = 0;

            #1;
            #1;

            check_outputs(31'h0002AAAA);
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
        input [30:0] expected_s_A;
        begin
            if (expected_s_A === (expected_s_A ^ s_A ^ expected_s_A)) begin
                $display("PASS");
                $display("  Outputs: s_A=%h",
                         s_A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_A=%h",
                         expected_s_A);
                $display("  Got:      s_A=%h",
                         s_A);
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
        $dumpvars(0,clk, in_A, load, shift, s_A);
    end

endmodule
