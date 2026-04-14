`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] val_a;
    reg [15:0] val_b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .val_a(val_a),
        .val_b(val_b),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            val_a = 0;
            val_b = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            val_a = 16'h0000;
            val_b = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            val_a = 16'h0005;
            val_b = 16'h000A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            val_a = 16'hFFFF;
            val_b = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            val_a = 16'hFFFF;
            val_b = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0001FFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            val_a = 16'h1234;
            val_b = 16'h5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h000068AC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            val_a = 16'h8000;
            val_b = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            val_a = 16'hAAAA;
            val_b = 16'hBBBB;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, rst, val_a, val_b, result);
    end

endmodule
