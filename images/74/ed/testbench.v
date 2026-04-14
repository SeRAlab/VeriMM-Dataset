`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg phy_tx_clk;
    reg s_axi_aresetn;
    wire scndry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .phy_tx_clk(phy_tx_clk),
        .s_axi_aresetn(s_axi_aresetn),
        .scndry_out(scndry_out)
    );

    // Clock generation (10ns period)
    initial begin
        phy_tx_clk = 0;
        forever #5 phy_tx_clk = ~phy_tx_clk;
    end

        task reset_dut;

        begin


            s_axi_aresetn = 1'b0;
            repeat(5) @(posedge phy_tx_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronizing Reset Release (Active-Low 0 -> 1)", test_num);
            reset_dut();


            @(posedge phy_tx_clk);
            s_axi_aresetn = 1'b1;


            repeat(10) @(posedge phy_tx_clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronizing Reset Activation (1 -> 0)", test_num);
            reset_dut();


            s_axi_aresetn = 1'b1;
            repeat(10) @(posedge phy_tx_clk);


            @(posedge phy_tx_clk);
            s_axi_aresetn = 1'b0;


            repeat(10) @(posedge phy_tx_clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stability Test - Holding Signal High", test_num);
            reset_dut();

            s_axi_aresetn = 1'b1;
            repeat(20) @(posedge phy_tx_clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rapid Toggle Capture", test_num);
            reset_dut();


            s_axi_aresetn = 1'b1;
            repeat(2) @(posedge phy_tx_clk);
            s_axi_aresetn = 1'b0;
            repeat(2) @(posedge phy_tx_clk);
            s_axi_aresetn = 1'b1;


            repeat(10) @(posedge phy_tx_clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Timing Offset Test", test_num);
            reset_dut();


            #3;
            s_axi_aresetn = 1'b1;


            repeat(10) @(posedge phy_tx_clk);

            #1;


            check_outputs(1'b1);
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
        input expected_scndry_out;
        begin
            if (expected_scndry_out === (expected_scndry_out ^ scndry_out ^ expected_scndry_out)) begin
                $display("PASS");
                $display("  Outputs: scndry_out=%b",
                         scndry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scndry_out=%b",
                         expected_scndry_out);
                $display("  Got:      scndry_out=%b",
                         scndry_out);
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
        $dumpvars(0,phy_tx_clk, s_axi_aresetn, scndry_out);
    end

endmodule
