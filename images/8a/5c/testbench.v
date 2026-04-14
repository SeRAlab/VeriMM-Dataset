`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    reg [7:0] y;
    wire [15:0] prod;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .prod(prod),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task wait_for_ready;

        begin

            repeat (20) begin
                if (ready) disable wait_for_ready;
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            x = 8'd3;
            y = 8'd5;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd15, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 8'd0;
            y = 8'd255;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 8'd128;
            y = 8'd0;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 8'd255;
            y = 8'd1;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd255, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 8'd255;
            y = 8'd255;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'hFE01, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 8'd16;
            y = 8'd8;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd128, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 8'd123;
            y = 8'd45;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd5535, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 8'd1;
            y = 8'd1;
            reset_dut();
            wait_for_ready();
            #1;

            check_outputs(16'd1, 1'b1);
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
        input [15:0] expected_prod;
        input expected_ready;
        begin
            if (expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: prod=%h, ready=%b",
                         prod, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h, ready=%b",
                         expected_prod, expected_ready);
                $display("  Got:      prod=%h, ready=%b",
                         prod, ready);
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
        $dumpvars(0,clk, reset, x, y, prod, ready);
    end

endmodule
