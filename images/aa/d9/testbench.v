`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg clk;
    wire [3:0] bcd_out1;
    wire [3:0] bcd_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .bcd_out1(bcd_out1),
        .bcd_out2(bcd_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bin_in = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd0;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 0", test_num);
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd5;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 5", test_num);
            #1;

            check_outputs(4'h0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd9;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 9", test_num);
            #1;

            check_outputs(4'h0, 4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd10;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 10", test_num);
            #1;

            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd12;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 12", test_num);
            #1;

            check_outputs(4'h1, 4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'd15;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Input 15", test_num);
            #1;

            check_outputs(4'h1, 4'h5);
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
        input [3:0] expected_bcd_out1;
        input [3:0] expected_bcd_out2;
        begin
            if (expected_bcd_out1 === (expected_bcd_out1 ^ bcd_out1 ^ expected_bcd_out1) &&
                expected_bcd_out2 === (expected_bcd_out2 ^ bcd_out2 ^ expected_bcd_out2)) begin
                $display("PASS");
                $display("  Outputs: bcd_out1=%h, bcd_out2=%h",
                         bcd_out1, bcd_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out1=%h, bcd_out2=%h",
                         expected_bcd_out1, expected_bcd_out2);
                $display("  Got:      bcd_out1=%h, bcd_out2=%h",
                         bcd_out1, bcd_out2);
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
        $dumpvars(0,bin_in, clk, bcd_out1, bcd_out2);
    end

endmodule
