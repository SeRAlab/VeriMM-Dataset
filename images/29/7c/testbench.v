`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x;
    wire [3:0] h;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .h(h),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Single-step", test_num);
            reset_dut();
            x = 4'd5;
            @(posedge clk);
            #1;
            x = 4'd2;
            #1;
            #1;

            check_outputs(4'd5, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Multi-step Accumulation", test_num);
            reset_dut();

            x = 4'd2; @(posedge clk); #1;

            x = 4'd3; @(posedge clk); #1;

            x = 4'd4;
            #1;
            #1;

            check_outputs(4'd5, 4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Overflow Handling", test_num);
            reset_dut();
            x = 4'd12; @(posedge clk); #1;
            x = 4'd6;
            #1;
            #1;

            check_outputs(4'd12, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Zero Input", test_num);
            reset_dut();
            x = 4'd7; @(posedge clk); #1;
            x = 4'd0;
            #1;
            #1;

            check_outputs(4'd7, 4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Reset mid-sequence", test_num);
            reset_dut();
            x = 4'd10; @(posedge clk); #1;
            reset_dut();
            x = 4'd3;
            #1;
            #1;

            check_outputs(4'd0, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Max Values", test_num);
            reset_dut();
            x = 4'hf; @(posedge clk); #1;
            x = 4'hf;
            #1;
            #1;

            check_outputs(4'hf, 4'he);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [3:0] expected_h;
        input [3:0] expected_y;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: h=%h, y=%h",
                         h, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h, y=%h",
                         expected_h, expected_y);
                $display("  Got:      h=%h, y=%h",
                         h, y);
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
        $dumpvars(0,clk, rst, x, h, y);
    end

endmodule
