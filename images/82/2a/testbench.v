`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg en;
    reg rst;
    reg wr_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            wr_en = 0;
            data_in = 16'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Loading Countdown Start Value", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1;
            data_in = 16'h5555;
            @(posedge clk);
            #1 wr_en = 0;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Basic Countdown (Enable active)", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1;
            data_in = 16'h000A;
            @(posedge clk);
            #1 wr_en = 0;
            en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0007);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Pause Countdown (Enable low)", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1;
            data_in = 16'h0020;
            @(posedge clk);
            #1 wr_en = 0;
            en = 1;
            @(posedge clk);
            @(posedge clk);
            #1 en = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h001E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Restart Countdown from Zero", test_num);
            reset_dut();
            @(posedge clk);
            wr_en = 1;
            data_in = 16'h0002;
            @(posedge clk);
            #1 wr_en = 0;
            en = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0002);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, en, rst, wr_en, data_out);
    end

endmodule
