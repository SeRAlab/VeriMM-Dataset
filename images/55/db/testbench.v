`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [7:0] random_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .random_num(random_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            if (clk === 1'bx) @(posedge clk);


            if (random_num !== 8'd11) begin
                repeat (260) begin
                    if (random_num === 8'd11) break;
                    @(posedge clk);
                end
            end

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify sequence starts at 11", test_num);
            reset_dut();
            #1;

            check_outputs(8'd11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify increment (11 -> 12)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify sequence after 100 increments", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify upper boundary (255)", test_num);
            reset_dut();
            repeat(244) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hff);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify wrap-around from 255 back to 11", test_num);
            reset_dut();
            repeat(245) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd11);
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
        input [7:0] expected_random_num;
        begin
            if (expected_random_num === (expected_random_num ^ random_num ^ expected_random_num)) begin
                $display("PASS");
                $display("  Outputs: random_num=%h",
                         random_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_num=%h",
                         expected_random_num);
                $display("  Got:      random_num=%h",
                         random_num);
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
        $dumpvars(0,clk, random_num);
    end

endmodule
