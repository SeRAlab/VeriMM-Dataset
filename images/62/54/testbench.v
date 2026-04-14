`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg load;
    reg rst;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
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
            en = 0;
            load = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset and Increment", test_num);
            reset_dut();
            en = 1;
            repeat (10) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Functionality", test_num);
            reset_dut();
            data_in = 32'hDEADBEEF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load and then Increment", test_num);
            reset_dut();
            data_in = 32'h00000FFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(32'h00001004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable Toggle", test_num);
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            en = 0;
            repeat (5) @(posedge clk);
            #1;
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Load Priority over Enable", test_num);
            reset_dut();
            data_in = 32'h5555AAAA;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 0;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            rst = 0;
            load = 1;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Counter Wraparound", test_num);
            reset_dut();
            data_in = 32'hFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Rapid Load Changes", test_num);
            reset_dut();
            load = 1;
            data_in = 32'h11111111;
            @(posedge clk);
            #1;
            data_in = 32'h22222222;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(32'h22222222);
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
        $dumpvars(0,clk, data_in, en, load, rst, count);
    end

endmodule
