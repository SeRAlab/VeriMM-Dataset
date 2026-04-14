`timescale 1ns/1ps

module DWT_4Sample_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
    wire [15:0] approx;
    wire [15:0] detail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_4Sample dut (
        .clk(clk),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .approx(approx),
        .detail(detail)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x0 = 0; x1 = 0; x2 = 0; x3 = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            x0 = 16'h0000; x1 = 16'h0000; x2 = 16'h0000; x3 = 16'h0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant DC Signal", test_num);
            reset_dut();
            x0 = 16'd1000; x1 = 16'd1000; x2 = 16'd1000; x3 = 16'd1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h03E8, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step Function (High-to-Low)", test_num);
            reset_dut();
            x0 = 16'd1000; x1 = 16'd1000; x2 = 16'd0; x3 = 16'd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01F4, 16'h01F4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step Function (Low-to-High)", test_num);
            reset_dut();
            x0 = 16'd0; x1 = 16'd0; x2 = 16'd1000; x3 = 16'd1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01F4, 16'hFE0C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Impulse", test_num);
            reset_dut();
            x0 = 16'd1000; x1 = 16'd0; x2 = 16'd0; x3 = 16'd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00FA, 16'h00FA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_4Sample Testbench");
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
        input [15:0] expected_approx;
        input [15:0] expected_detail;
        begin
            if (expected_approx === (expected_approx ^ approx ^ expected_approx) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail)) begin
                $display("PASS");
                $display("  Outputs: approx=%h, detail=%h",
                         approx, detail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx=%h, detail=%h",
                         expected_approx, expected_detail);
                $display("  Got:      approx=%h, detail=%h",
                         approx, detail);
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
        $dumpvars(0,clk, reset, x0, x1, x2, x3, approx, detail);
    end

endmodule
