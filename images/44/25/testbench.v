`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [63:0] reg_in;
    reg reset;
    wire [63:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .reg_in(reg_in),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            reg_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 64-bit hex value", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            reg_in = 64'hFEDCBA9876543210;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load All Ones", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            reg_in = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold value when load=0", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            reg_in = 64'hAAAA5555AAAA5555;
            @(posedge clk);
            #1;

            @(negedge clk);
            load = 0;
            reg_in = 64'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hAAAA5555AAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-cycle hold", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            reg_in = 64'h1234567812345678;
            @(posedge clk);
            #1;
            load = 0;
            reg_in = 64'hFFFFFFFFFFFFFFFF;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h1234567812345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority over load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            reset = 1;
            reg_in = 64'hDEADBEEFDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
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
        input [63:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, load, reg_in, reset, reg_out);
    end

endmodule
