`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg clk;
    reg reset;
    wire [2:0] ones_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .reset(reset),
        .ones_count(ones_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            binary_in = 4'b0000;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b0000;
            @(posedge clk);
            #2;
            $display("Testcase001: binary_in = 4'b0000");
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b0001;
            @(posedge clk);
            #2;
            $display("Testcase002: binary_in = 4'b0001");
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b1000;
            @(posedge clk);
            #2;
            $display("Testcase003: binary_in = 4'b1000");
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b1010;
            @(posedge clk);
            #2;
            $display("Testcase004: binary_in = 4'b1010");
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b0110;
            @(posedge clk);
            #2;
            $display("Testcase005: binary_in = 4'b0110");
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b0111;
            @(posedge clk);
            #2;
            $display("Testcase006: binary_in = 4'b0111");
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b1111;
            @(posedge clk);
            #2;
            $display("Testcase007: binary_in = 4'b1111");
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'b1111;
            @(posedge clk);
            #2;

            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #2;
            $display("Testcase008: Reset asserted with input 1111");
            #1;

            check_outputs(3'd0);
            reset = 0;
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
        input [2:0] expected_ones_count;
        begin
            if (expected_ones_count === (expected_ones_count ^ ones_count ^ expected_ones_count)) begin
                $display("PASS");
                $display("  Outputs: ones_count=%h",
                         ones_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones_count=%h",
                         expected_ones_count);
                $display("  Got:      ones_count=%h",
                         ones_count);
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
        $dumpvars(0,binary_in, clk, reset, ones_count);
    end

endmodule
