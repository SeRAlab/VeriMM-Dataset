`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] X;
    reg acc_update;
    reg clk;
    reg rst;
    wire [7:0] acc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .acc_update(acc_update),
        .clk(clk),
        .rst(rst),
        .acc(acc)
    );

        task reset_dut;

    begin
        rst = 1;
        X = 8'h00;
        acc_update = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Update (0xAA)", test_num);
        reset_dut();

        X = 8'hAA;
        acc_update = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hold Value (acc_update=0)", test_num);
        reset_dut();


        X = 8'h55;
        acc_update = 1;
        @(posedge clk);


        #1 X = 8'hFF;
        acc_update = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Sequential Updates", test_num);
        reset_dut();


        X = 8'h01; acc_update = 1; @(posedge clk);
        #1 X = 8'h02; acc_update = 1; @(posedge clk);
        #1 X = 8'h03; acc_update = 1; @(posedge clk);

        #1;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Priority over Update", test_num);
        reset_dut();


        X = 8'hFF;
        acc_update = 1;
        @(posedge clk);


        #1 rst = 1;
        X = 8'h12;
        acc_update = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Loading Max Value (0xFF)", test_num);
        reset_dut();

        X = 8'hFF;
        acc_update = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_acc;
        begin
            if (expected_acc === (expected_acc ^ acc ^ expected_acc)) begin
                $display("PASS");
                $display("  Outputs: acc=%h",
                         acc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc=%h",
                         expected_acc);
                $display("  Got:      acc=%h",
                         acc);
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
        $dumpvars(0,X, acc_update, clk, rst, acc);
    end

endmodule
