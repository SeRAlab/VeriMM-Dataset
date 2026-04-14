`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg enable;
    reg reset;
    wire [3:0] count;
    wire max_min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .enable(enable),
        .reset(reset),
        .count(count),
        .max_min(max_min)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            control = 1;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment to 5", test_num);
            reset_dut();
            control = 1;
            enable = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment to Max (15)", test_num);
            reset_dut();
            control = 1;
            enable = 1;
            repeat (15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around from 15 to 0", test_num);
            reset_dut();
            control = 1;
            enable = 1;
            repeat (16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decrement from 0 (Wrap to 15)", test_num);
            reset_dut();
            control = 0;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Decrement to Min (0)", test_num);
            reset_dut();

            control = 1;
            enable = 1;
            repeat (2) @(posedge clk);

            control = 0;
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Deactivated Check", test_num);
            reset_dut();
            control = 1;
            enable = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direction Change mid-count", test_num);
            reset_dut();
            enable = 1;
            control = 1;
            repeat (10) @(posedge clk);
            control = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Toggle", test_num);
            reset_dut();
            control = 1;
            enable = 1;
            repeat (3) @(posedge clk);
            enable = 0;
            repeat (3) @(posedge clk);
            enable = 1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold at Max with Enable=0", test_num);
            reset_dut();
            control = 1;
            enable = 1;
            repeat (15) @(posedge clk);
            enable = 0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b1);
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
        testcase010();
        
        
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
        input expected_max_min;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_min === (expected_max_min ^ max_min ^ expected_max_min)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_min=%b",
                         count, max_min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_min=%b",
                         expected_count, expected_max_min);
                $display("  Got:      count=%h, max_min=%b",
                         count, max_min);
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
        $dumpvars(0,clk, control, enable, reset, count, max_min);
    end

endmodule
