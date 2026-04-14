`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bin;
    reg clk;
    reg rst;
    wire [2:0] dec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .rst(rst),
        .dec(dec)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bin = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd5));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd10;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd10));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd50;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd50));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd100;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd100));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = -8'd7;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(-8'd7));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = -8'd45;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(-8'd45));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd0));
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'd120;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd120));
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 8'h80;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'h80));
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();



            bin = 8'd200;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(get_expected(8'd200));
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
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_dec;
        begin
            if (expected_dec === (expected_dec ^ dec ^ expected_dec)) begin
                $display("PASS");
                $display("  Outputs: dec=%h",
                         dec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec=%h",
                         expected_dec);
                $display("  Got:      dec=%h",
                         dec);
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
        $dumpvars(0,bin, clk, rst, dec);
    end

endmodule
