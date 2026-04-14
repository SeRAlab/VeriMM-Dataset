`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg load;
    reg up_down;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .load(load),
        .up_down(up_down),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D = 4'b0000;
            load = 1;
            up_down = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);
        end
        endtask
    task load_value;

        input [3:0] val;
        begin
            D = val;
            load = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);
        end
        endtask

    task testcase001;

        begin
            $display("Test 001: Load Zero Check");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Load Value 10 Check");
            reset_dut();
            load_value(4'hA);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Up Counter Increment from 0");
            reset_dut();
            up_down = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Up Counter Wrap (15 to 0)");
            reset_dut();
            load_value(4'hF);
            up_down = 1;
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Down Counter Decrement from 10");
            reset_dut();
            load_value(4'hA);
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Down Counter Wrap (0 to 15)");
            reset_dut();
            load_value(4'h0);
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Interleaved Up and Down steps");
            reset_dut();
            load_value(4'h5);
            up_down = 1;
            @(negedge clk);
            @(negedge clk);
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Up Counter full 16 cycles");
            reset_dut();
            load_value(4'h8);
            up_down = 1;
            repeat(16) @(negedge clk);
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,D, clk, load, up_down, OUT);
    end

endmodule
