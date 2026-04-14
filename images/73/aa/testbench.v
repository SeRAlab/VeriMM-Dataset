`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Accumulation", test_num);
            reset_dut();
            @(posedge clk) data_in = 8'd10;
            @(posedge clk) data_in = 8'd20;
            @(posedge clk) data_in = 8'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Overflow Check", test_num);
            reset_dut();
            @(posedge clk) data_in = 8'd200;
            @(posedge clk) data_in = 8'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();
            @(posedge clk) data_in = 8'hFF;
            @(posedge clk) rst = 1;
            @(posedge clk) rst = 0;
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Adding Zero", test_num);
            reset_dut();
            @(posedge clk) data_in = 8'd55;
            @(posedge clk) data_in = 8'd0;
            @(posedge clk) data_in = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Max Values (8'hFF + 8'hFF)", test_num);
            reset_dut();
            @(posedge clk) data_in = 8'hFF;
            @(posedge clk) data_in = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Single Increments", test_num);
            reset_dut();
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk) data_in = 8'd1;
            end
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, data_in, rst, out);
    end

endmodule
