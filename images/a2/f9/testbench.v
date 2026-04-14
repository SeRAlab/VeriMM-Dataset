`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [1:0] i_data;
    reg reset;
    wire [15:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .i_data(i_data),
        .reset(reset),
        .o_data(o_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            i_data = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO with all 1s", test_num);
            reset_dut();
            en = 1;
            i_data = 2'b11;
            repeat(8) @(posedge clk);
            en = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Pattern (01-10-11-00 x2)", test_num);
            reset_dut();
            en = 1;
            i_data = 2'b01; @(posedge clk);
            i_data = 2'b10; @(posedge clk);
            i_data = 2'b11; @(posedge clk);
            i_data = 2'b00; @(posedge clk);
            i_data = 2'b01; @(posedge clk);
            i_data = 2'b10; @(posedge clk);
            i_data = 2'b11; @(posedge clk);
            i_data = 2'b00; @(posedge clk);
            en = 0;

            #1;


            check_outputs(16'h6C6C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable Gating", test_num);
            reset_dut();
            en = 1;
            i_data = 2'b11;
            repeat(4) @(posedge clk);
            en = 0;
            i_data = 2'b01;
            repeat(4) @(posedge clk);
            en = 1;
            i_data = 2'b10;
            repeat(4) @(posedge clk);
            en = 0;

            #1;


            check_outputs(16'hFFAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FIFO Overflow (Oldest data discard)", test_num);
            reset_dut();
            en = 1;
            i_data = 2'b11;
            repeat(4) @(posedge clk);
            i_data = 2'b01;
            repeat(8) @(posedge clk);
            en = 0;

            #1;


            check_outputs(16'h5555);
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
        input [15:0] expected_o_data;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
        $dumpvars(0,clk, en, i_data, reset, o_data);
    end

endmodule
