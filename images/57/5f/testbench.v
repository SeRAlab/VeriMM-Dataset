`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address0;
    reg ce0;
    reg clk;
    reg reset;
    wire [7:0] q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address0(address0),
        .ce0(ce0),
        .clk(clk),
        .reset(reset),
        .q0(q0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ce0 = 0;
            address0 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reading Address 0 (CE=1)", test_num);
            reset_dut();
            address0 = 8'h00;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reading Address 128 (CE=1)", test_num);
            reset_dut();
            address0 = 8'd128;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reading Address 255 (CE=1)", test_num);
            reset_dut();
            address0 = 8'hFF;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reading Address 64 with CE=0 (Should be Low)", test_num);
            reset_dut();
            address0 = 8'd64;
            ce0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reading Address 17", test_num);
            reset_dut();
            address0 = 8'd17;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd17);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple reads without intermediate reset", test_num);
            reset_dut();


            address0 = 8'd10;
            ce0 = 1;
            @(posedge clk);
            #1;


            address0 = 8'd20;
            ce0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd20);
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
        input [7:0] expected_q0;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0)) begin
                $display("PASS");
                $display("  Outputs: q0=%h",
                         q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h",
                         expected_q0);
                $display("  Got:      q0=%h",
                         q0);
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
        $dumpvars(0,address0, ce0, clk, reset, q0);
    end

endmodule
