`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] inData;
    reg wr0a;
    reg wr0b;
    reg wr1a;
    reg wr1b;
    wire [15:0] out0;
    wire [15:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inData(inData),
        .wr0a(wr0a),
        .wr0b(wr0b),
        .wr1a(wr1a),
        .wr1b(wr1b),
        .out0(out0),
        .out1(out1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr0a = 1; wr0b = 0; wr1a = 1; wr1b = 0;
            inData = 16'h0000;
            @(posedge clk);
            #1;
            wr0a = 0; wr1a = 0;
            inData = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Writing 0xAAAA to Entry 0 (wr0a)", test_num);
            reset_dut();
            inData = 16'hAAAA;
            wr0a = 1;
            @(posedge clk);
            #1;
            wr0a = 0;

            #1;


            check_outputs(16'h0000, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Writing 0x5555 negated to Entry 0 (wr0b)", test_num);
            reset_dut();
            inData = 16'h5555;
            wr0b = 1;
            @(posedge clk);
            #1;
            wr0b = 0;

            #1;


            check_outputs(16'hFFFF, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Writing 0xBBBB to Entry 1 (wr1a)", test_num);
            reset_dut();
            inData = 16'hBBBB;
            wr1a = 1;
            @(posedge clk);
            #1;
            wr1a = 0;

            #1;


            check_outputs(16'hBBBB, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Writing 0xCCCC negated to Entry 1 (wr1b)", test_num);
            reset_dut();
            inData = 16'hCCCC;
            wr1b = 1;
            @(posedge clk);
            #1;
            wr1b = 0;

            #1;


            check_outputs(16'hCCCC, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequential Write and Processed Retrieval", test_num);
            reset_dut();

            inData = 16'h1234; wr0a = 1;
            @(posedge clk); #1;
            wr0a = 0;

            inData = 16'h5678; wr1a = 1;
            @(posedge clk); #1;
            wr1a = 0;


            #1;



            check_outputs(16'h444C, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Writes to Entry 0 and Entry 1", test_num);
            reset_dut();
            inData = 16'hABCD;
            wr0a = 1;
            wr1b = 1;
            @(posedge clk);
            #1;
            wr0a = 0; wr1b = 0;


            #1;



            check_outputs(16'h0000, 16'hFFFF);
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
        input [15:0] expected_out0;
        input [15:0] expected_out1;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h",
                         out0, out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h",
                         expected_out0, expected_out1);
                $display("  Got:      out0=%h, out1=%h",
                         out0, out1);
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
        $dumpvars(0,clk, inData, wr0a, wr0b, wr1a, wr1b, out0, out1);
    end

endmodule
