`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [3:0] nedge_clear;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .nedge_clear(nedge_clear)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 4'b0000;
            repeat(3) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 4'b0001;
            @(negedge clk);
            in = 4'b0000;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 4'b1111;
            @(negedge clk);
            in = 4'b0000;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 4'b1010;
            @(negedge clk);
            in = 4'b0110;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 4'b0000;
            @(negedge clk);
            in = 4'b1111;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 4'b1111;
            @(negedge clk);
            in = 4'b1111;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 4'b0000;
            @(negedge clk);
            in = 4'b1111;
            @(negedge clk);
            in = 4'b0000;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in = 4'b1010;
            @(negedge clk);
            in = 4'b0000;
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'b1010);
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
        input [3:0] expected_nedge_clear;
        begin
            if (expected_nedge_clear === (expected_nedge_clear ^ nedge_clear ^ expected_nedge_clear)) begin
                $display("PASS");
                $display("  Outputs: nedge_clear=%h",
                         nedge_clear);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nedge_clear=%h",
                         expected_nedge_clear);
                $display("  Got:      nedge_clear=%h",
                         nedge_clear);
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
        $dumpvars(0,clk, in, nedge_clear);
    end

endmodule
