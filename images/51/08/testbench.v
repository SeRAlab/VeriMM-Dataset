`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] binary_num;
    reg clk;
    reg reset;
    wire [2:0] count_ones;
    wire is_fibonacci;
    wire is_gte5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .count_ones(count_ones),
        .is_fibonacci(is_fibonacci),
        .is_gte5(is_gte5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            binary_num = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 0", test_num);
            binary_num = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 1", test_num);
            binary_num = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 2", test_num);
            binary_num = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 3", test_num);
            binary_num = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 4", test_num);
            binary_num = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 5", test_num);
            binary_num = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 6", test_num);
            binary_num = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd2, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 7", test_num);
            binary_num = 3'b111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Synchronous Reset Check", test_num);

            binary_num = 3'b111;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0, 1'b0, 1'b0);
            reset = 0;
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
        testcase009();
        
        
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
        input [2:0] expected_count_ones;
        input expected_is_fibonacci;
        input expected_is_gte5;
        begin
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_is_fibonacci === (expected_is_fibonacci ^ is_fibonacci ^ expected_is_fibonacci) &&
                expected_is_gte5 === (expected_is_gte5 ^ is_gte5 ^ expected_is_gte5)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, is_fibonacci=%b, is_gte5=%b",
                         count_ones, is_fibonacci, is_gte5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, is_fibonacci=%b, is_gte5=%b",
                         expected_count_ones, expected_is_fibonacci, expected_is_gte5);
                $display("  Got:      count_ones=%h, is_fibonacci=%b, is_gte5=%b",
                         count_ones, is_fibonacci, is_gte5);
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
        $dumpvars(0,binary_num, clk, reset, count_ones, is_fibonacci, is_gte5);
    end

endmodule
