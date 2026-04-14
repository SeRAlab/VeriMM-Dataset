`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Idle Input", test_num);
            reset_dut();
            in = 4'b0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bit 0 active for 3 cycles", test_num);
            reset_dut();
            in = 4'b0001;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit 3 active for 5 cycles", test_num);
            reset_dut();
            in = 4'b1000;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dynamic input changes", test_num);
            reset_dut();
            in = 4'b0001; @(posedge clk);
            in = 4'b0010; @(posedge clk);
            in = 4'b0100; @(posedge clk);
            in = 4'b1000; @(posedge clk);
            in = 4'b0000; @(posedge clk);
            #1;

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Priority overlap (multiple bits set)", test_num);
            reset_dut();
            in = 4'b1011;
            repeat(2) @(posedge clk);
            in = 4'b0110;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: 4-bit Counter Wraparound", test_num);
            reset_dut();
            in = 4'b1111;
            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset during active count", test_num);
            reset_dut();
            in = 4'b0001;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            in = 4'b0001;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd2);
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, in, reset, count);
    end

endmodule
