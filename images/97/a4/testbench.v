`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
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
            data = 10'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic 101 Detection", test_num);
            reset_dut();
            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No sequence (All 0s and All 1s)", test_num);
            reset_dut();
            data = 10'h3FF; @(posedge clk);
            data = 10'h3FF; @(posedge clk);
            data = 10'h3FF; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h000; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overlapping 10101", test_num);
            reset_dut();
            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two separate sequences", test_num);
            reset_dut();

            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);

            data = 10'h000; @(posedge clk);
            data = 10'h000; @(posedge clk);

            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset mid-operation", test_num);
            reset_dut();
            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            @(posedge clk); #1;

            reset = 1; @(posedge clk); #1 reset = 0;

            data = 10'h001; @(posedge clk);
            data = 10'h000; @(posedge clk);
            data = 10'h001; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ignore upper bits [9:1]", test_num);
            reset_dut();

            data = 10'b1111111111; @(posedge clk);
            data = 10'b1010101010; @(posedge clk);
            data = 10'b0000000001; @(posedge clk);
            @(posedge clk); #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple sequences (Count up to 5)", test_num);
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                data = 10'h001; @(posedge clk);
                data = 10'h000; @(posedge clk);
                data = 10'h001; @(posedge clk);
                data = 10'h000; @(posedge clk);
            end
            @(posedge clk); #1;
            #1;

            check_outputs(4'd5);
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
        $dumpvars(0,clk, data, reset, count);
    end

endmodule
