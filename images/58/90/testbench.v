`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    wire [1:0] com;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .com(com),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 4'h0;
            in1 = 4'h0;
            repeat(5) @(posedge clk);
        end
        endtask
    task wait_for_com;

        input [1:0] target_com;
        integer timeout;
        begin
            timeout = 0;
            while (com !== target_com && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in0 = 4'h0;
            in1 = 4'hF;
            wait_for_com(2'b01);
            #1;
            $display("Test %0d: Checking in0 = 4'h0", test_num);
            #1;

            check_outputs(2'b01, get_seg(4'h0));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in0 = 4'h0;
            in1 = 4'h1;
            wait_for_com(2'b10);
            #1;
            $display("Test %0d: Checking in1 = 4'h1", test_num);
            #1;

            check_outputs(2'b10, get_seg(4'h1));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in0 = 4'hA;
            in1 = 4'hB;
            wait_for_com(2'b01);
            #1;
            $display("Test %0d: Checking in0 = 4'hA", test_num);
            #1;

            check_outputs(2'b01, get_seg(4'hA));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in0 = 4'h5;
            in1 = 4'h7;
            wait_for_com(2'b10);
            #1;
            $display("Test %0d: Checking in1 = 4'h7", test_num);
            #1;

            check_outputs(2'b10, get_seg(4'h7));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in0 = 4'hE;
            in1 = 4'h2;
            wait_for_com(2'b10);
            wait_for_com(2'b01);
            #1;
            $display("Test %0d: Checking cycling back to in0 = 4'hE", test_num);
            #1;

            check_outputs(2'b01, get_seg(4'hE));
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
        input [1:0] expected_com;
        input [7:0] expected_out;
        begin
            if (expected_com === (expected_com ^ com ^ expected_com) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: com=%h, out=%h",
                         com, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: com=%h, out=%h",
                         expected_com, expected_out);
                $display("  Got:      com=%h, out=%h",
                         com, out);
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
        $dumpvars(0,clk, in0, in1, com, out);
    end

endmodule
