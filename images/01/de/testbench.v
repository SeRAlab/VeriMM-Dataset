`timescale 1ns/1ps

module LMS_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] mu;
    reg reset;
    reg [15:0] x;
    wire [15:0] w0;
    wire [15:0] w1;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LMS_Filter dut (
        .clk(clk),
        .d(d),
        .mu(mu),
        .reset(reset),
        .x(x),
        .w0(w0),
        .w1(w1),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 16'h0000;
            d = 16'h0000;
            mu = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: No Adaptation (mu=0)", test_num);
            reset_dut();
            x = 16'h000A;
            d = 16'h0064;
            mu = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Single Update", test_num);
            reset_dut();
            x = 16'h0002;
            d = 16'h000A;
            mu = 16'h0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0014, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Two-Tap Sequential Update", test_num);
            reset_dut();

            x = 16'h0002; d = 16'h000A; mu = 16'h0001;
            @(posedge clk);
            #1;

            x = 16'h0004; d = 16'h0064;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0064, 16'h0028, 16'h0050);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Zero Input Check", test_num);
            reset_dut();
            x = 16'h0000;
            d = 16'h00FF;
            mu = 16'h0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LMS_Filter Testbench");
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
        input [15:0] expected_w0;
        input [15:0] expected_w1;
        input [15:0] expected_y;
        begin
            if (expected_w0 === (expected_w0 ^ w0 ^ expected_w0) &&
                expected_w1 === (expected_w1 ^ w1 ^ expected_w1) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w0=%h, w1=%h, y=%h",
                         w0, w1, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w0=%h, w1=%h, y=%h",
                         expected_w0, expected_w1, expected_y);
                $display("  Got:      w0=%h, w1=%h, y=%h",
                         w0, w1, y);
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
        $dumpvars(0,clk, d, mu, reset, x, w0, w1, y);
    end

endmodule
