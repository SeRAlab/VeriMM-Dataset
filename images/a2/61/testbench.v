`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] in;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 5'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Input = 0");
            reset_dut();
            in = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b00_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input = 5");
            reset_dut();
            in = 5'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b00_0101);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input = 9");
            reset_dut();
            in = 5'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b00_1001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input = 10");
            reset_dut();
            in = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b01_0000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input = 15");
            reset_dut();
            in = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b01_0101);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input = 20");
            reset_dut();
            in = 5'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b10_0000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input = 29");
            reset_dut();
            in = 5'd29;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b10_1001);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input = 31");
            reset_dut();
            in = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b11_0001);
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
        input [5:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
