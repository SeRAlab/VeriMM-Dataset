`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gmii_rxen;
    reg gmii_txen;
    reg reset;
    wire r_act_sfp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gmii_rxen(gmii_rxen),
        .gmii_txen(gmii_txen),
        .reset(reset),
        .r_act_sfp(r_act_sfp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            gmii_rxen = 0;
            gmii_txen = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle state after reset", test_num);
            reset_dut();
            gmii_rxen = 0;
            gmii_txen = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RX activity detection", test_num);
            reset_dut();
            @(posedge clk);
            gmii_rxen = 1;
            gmii_txen = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: TX activity detection", test_num);
            reset_dut();
            @(posedge clk);
            gmii_rxen = 0;
            gmii_txen = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous RX and TX activity", test_num);
            reset_dut();
            @(posedge clk);
            gmii_rxen = 1;
            gmii_txen = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Return to idle after activity", test_num);
            reset_dut();

            gmii_rxen = 1;
            repeat(2) @(posedge clk);

            gmii_rxen = 0;
            gmii_txen = 0;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset override during activity", test_num);
            reset_dut();
            gmii_rxen = 1;
            gmii_txen = 1;
            repeat(2) @(posedge clk);

            reset = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_r_act_sfp;
        begin
            if (expected_r_act_sfp === (expected_r_act_sfp ^ r_act_sfp ^ expected_r_act_sfp)) begin
                $display("PASS");
                $display("  Outputs: r_act_sfp=%b",
                         r_act_sfp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_act_sfp=%b",
                         expected_r_act_sfp);
                $display("  Got:      r_act_sfp=%b",
                         r_act_sfp);
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
        $dumpvars(0,clk, gmii_rxen, gmii_txen, reset, r_act_sfp);
    end

endmodule
