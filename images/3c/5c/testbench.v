`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x;
    wire [3:0] h;
    wire y;

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
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single input below threshold");
            test_num = 2;
            reset_dut();
            x = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single input above threshold");
            test_num = 3;
            reset_dut();
            x = 4'd9;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Sequence accumulation");
            test_num = 4;
            reset_dut();
            x = 4'd2; @(posedge clk);
            x = 4'd3; @(posedge clk);
            x = 4'd4; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Max input check");
            test_num = 5;
            reset_dut();
            x = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b1);
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
        input expected_y;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: h=%h, y=%b",
                         h, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h, y=%b",
                         expected_h, expected_y);
                $display("  Got:      h=%h, y=%b",
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
