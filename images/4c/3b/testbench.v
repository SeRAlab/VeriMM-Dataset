`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DataOut_i;
    reg TxValid_i;
    reg clk;
    reg rst;
    wire hold_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataOut_i(DataOut_i),
        .TxValid_i(TxValid_i),
        .clk(clk),
        .rst(rst),
        .hold_reg(hold_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            DataOut_i = 0;
            TxValid_i = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Idle", test_num);
            reset_dut();

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Capture '1'", test_num);
            reset_dut();


            DataOut_i = 1;
            TxValid_i = 1;
            @(posedge clk);
            #1;
            TxValid_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Capture '0' after '1'", test_num);
            reset_dut();


            DataOut_i = 1;
            TxValid_i = 1;
            @(posedge clk);
            #1 TxValid_i = 0;
            @(posedge clk);


            #1;
            DataOut_i = 0;
            TxValid_i = 1;
            @(posedge clk);
            #1 TxValid_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: No capture when TxValid_i is low", test_num);
            reset_dut();

            DataOut_i = 1;
            TxValid_i = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Hold persistence", test_num);
            reset_dut();


            DataOut_i = 1;
            TxValid_i = 1;
            @(posedge clk);
            #1 TxValid_i = 0;
            @(posedge clk);


            #1;
            DataOut_i = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Back-to-back pulses", test_num);
            reset_dut();


            DataOut_i = 1;
            TxValid_i = 1;
            @(posedge clk);
            #1;




            DataOut_i = 0;
            TxValid_i = 1;
            @(posedge clk);
            #1;


            TxValid_i = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0);
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
        input expected_hold_reg;
        begin
            if (expected_hold_reg === (expected_hold_reg ^ hold_reg ^ expected_hold_reg)) begin
                $display("PASS");
                $display("  Outputs: hold_reg=%b",
                         hold_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hold_reg=%b",
                         expected_hold_reg);
                $display("  Got:      hold_reg=%b",
                         hold_reg);
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
        $dumpvars(0,DataOut_i, TxValid_i, clk, rst, hold_reg);
    end

endmodule
