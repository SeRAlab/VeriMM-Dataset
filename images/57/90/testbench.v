`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] in;
    wire [5:0] xor_prev;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .xor_prev(xor_prev)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 6'b0;


            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 6'h01;
            @(posedge clk);
            #1;
            $display("Test %0d: Transition 0x00 -> 0x01", test_num);
            #1;

            check_outputs(6'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 6'h3F;
            @(posedge clk);
            #1;
            $display("Test %0d: Transition 0x00 -> 0x3F", test_num);
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 6'h3F;
            @(posedge clk);
            in = 6'h00;
            @(posedge clk);
            #1;
            $display("Test %0d: Transition 0x3F -> 0x00", test_num);
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 6'h2A;
            @(posedge clk);
            in = 6'h2A;
            @(posedge clk);
            #1;
            $display("Test %0d: No change (0x2A -> 0x2A)", test_num);
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 6'h15;
            @(posedge clk);
            in = 6'h2A;
            @(posedge clk);
            #1;
            $display("Test %0d: Pattern flip (0x15 -> 0x2A)", test_num);
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 6'h12;
            @(posedge clk);
            in = 6'h34;
            @(posedge clk);
            #1;
            $display("Test %0d: Sequence transition (0x12 -> 0x34)", test_num);
            #1;

            check_outputs(6'h26);
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
        input [5:0] expected_xor_prev;
        begin
            if (expected_xor_prev === (expected_xor_prev ^ xor_prev ^ expected_xor_prev)) begin
                $display("PASS");
                $display("  Outputs: xor_prev=%h",
                         xor_prev);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xor_prev=%h",
                         expected_xor_prev);
                $display("  Got:      xor_prev=%h",
                         xor_prev);
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
        $dumpvars(0,clk, in, xor_prev);
    end

endmodule
