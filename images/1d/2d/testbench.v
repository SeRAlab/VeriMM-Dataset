`timescale 1ns/1ps

module lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lms_filter dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .x(x),
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
            d = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Zero Input / Zero Desired");
            reset_dut();
            repeat(10) begin
                x = 16'h0000;
                d = 16'h0000;
                @(posedge clk);
            end
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: DC Signal Convergence (x=10, d=10)");
            reset_dut();

            repeat(200) begin
                x = 16'h000A;
                d = 16'h000A;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Scaling/Gain Adaptation (d = 2 * x)");
            reset_dut();
            repeat(500) begin
                x = 16'h0005;
                d = 16'h000A;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Convergence to Zero (d=0)");
            reset_dut();
            repeat(300) begin
                x = 16'h00FF;
                d = 16'h0000;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Negative Coefficient Adaptation");
            reset_dut();
            repeat(500) begin
                x = 16'h0010;
                d = 16'hFFF0;
                @(posedge clk);
            end
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lms_filter Testbench");
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, rst, x, y);
    end

endmodule
