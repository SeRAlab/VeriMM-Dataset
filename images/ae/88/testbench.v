`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [2:0] pos;

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
            in = 8'b0000_0000;
            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 8'b0000_0000;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 8'b0000_0001;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 8'b1000_0000;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 8'b0001_0000;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 8'b1000_0001;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in = 8'b0011_1000;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in = 8'b1111_1111;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in = 8'b0000_0010;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1);
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
        input [2:0] expected_pos;
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
