`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] inc_value;
    reg rst;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .inc_value(inc_value),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            enable = 0;
            inc_value = 0;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            inc_value = 32'd1;
            enable = 1;

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(32'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            inc_value = 32'd5;
            enable = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            inc_value = 32'h1000;
            enable = 1;
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(32'h00004000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            inc_value = 32'h80000000;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            inc_value = 32'hFFFFFFFF;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, inc_value, rst, count);
    end

endmodule
