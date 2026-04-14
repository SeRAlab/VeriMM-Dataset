`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg tx_clk;
    reg tx_data_n;
    reg tx_data_p;
    wire tx_data_out_n;
    wire tx_data_out_p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .tx_clk(tx_clk),
        .tx_data_n(tx_data_n),
        .tx_data_p(tx_data_p),
        .tx_data_out_n(tx_data_out_n),
        .tx_data_out_p(tx_data_out_p)
    );

    // Clock generation (10ns period)
    initial begin
        tx_clk = 0;
        forever #5 tx_clk = ~tx_clk;
    end

        task reset_dut;

        begin
            tx_data_p = 0;
            tx_data_n = 0;
            @(posedge tx_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Data_P=0, Data_N=0 - Checking Rising Edge", test_num);
            tx_data_p = 0;
            tx_data_n = 0;
            @(posedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Data_P=1, Data_N=0 - Checking Rising Edge", test_num);
            tx_data_p = 1;
            tx_data_n = 0;
            @(posedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Data_P=1, Data_N=0 - Checking Falling Edge", test_num);
            tx_data_p = 1;
            tx_data_n = 0;
            @(negedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Data_P=0, Data_N=1 - Checking Rising Edge", test_num);
            tx_data_p = 0;
            tx_data_n = 1;
            @(posedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data_P=0, Data_N=1 - Checking Falling Edge", test_num);
            tx_data_p = 0;
            tx_data_n = 1;
            @(negedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Data_P=1, Data_N=1 - Checking Rising Edge", test_num);
            tx_data_p = 1;
            tx_data_n = 1;
            @(posedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Data_P=1, Data_N=1 - Checking Falling Edge", test_num);
            tx_data_p = 1;
            tx_data_n = 1;
            @(negedge tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Constant Complementary Output Check", test_num);
            tx_data_p = 1;
            tx_data_n = 1;
            repeat(4) @(tx_clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_tx_data_out_n;
        input expected_tx_data_out_p;
        begin
            if (expected_tx_data_out_n === (expected_tx_data_out_n ^ tx_data_out_n ^ expected_tx_data_out_n) &&
                expected_tx_data_out_p === (expected_tx_data_out_p ^ tx_data_out_p ^ expected_tx_data_out_p)) begin
                $display("PASS");
                $display("  Outputs: tx_data_out_n=%b, tx_data_out_p=%b",
                         tx_data_out_n, tx_data_out_p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_data_out_n=%b, tx_data_out_p=%b",
                         expected_tx_data_out_n, expected_tx_data_out_p);
                $display("  Got:      tx_data_out_n=%b, tx_data_out_p=%b",
                         tx_data_out_n, tx_data_out_p);
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
        $dumpvars(0,tx_clk, tx_data_n, tx_data_p, tx_data_out_n, tx_data_out_p);
    end

endmodule
