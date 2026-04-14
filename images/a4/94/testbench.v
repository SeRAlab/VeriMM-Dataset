`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 4'b0000;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b1000;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 001: Input 1000");
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0100;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 002: Input 0100");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0010;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 003: Input 0010");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0001;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 004: Input 0001");
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b1111;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 005: Input 1111 (Bit 3 should win)");
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0111;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 006: Input 0111 (Bit 2 should win)");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0011;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 007: Input 0011 (Bit 1 should win)");
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            in <= 4'b0000;
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 008: Input 0000");


            #1;



            check_outputs(2'b00);
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
        input [1:0] expected_pos;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
        $dumpvars(0,clk, in, pos);
    end

endmodule
