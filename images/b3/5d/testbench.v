`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PRE;
    reg [31:0] TMRCMP1;
    reg [31:0] TMRCMP2;
    reg TMREN;
    reg clk;
    reg rst;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PRE(PRE),
        .TMRCMP1(TMRCMP1),
        .TMRCMP2(TMRCMP2),
        .TMREN(TMREN),
        .clk(clk),
        .rst(rst),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            PRE = 0;
            TMRCMP1 = 0;
            TMRCMP2 = 0;
            TMREN = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic PWM High Phase", test_num);
            reset_dut();
            PRE = 32'd0;
            TMRCMP1 = 32'd10;
            TMRCMP2 = 32'd5;
            TMREN = 1'b1;

            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PWM Reset at TMRCMP1", test_num);
            reset_dut();
            PRE = 32'd0;
            TMRCMP1 = 32'd10;
            TMRCMP2 = 32'd5;
            TMREN = 1'b1;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clock Divider PRE=1", test_num);
            reset_dut();
            PRE = 32'd1;
            TMRCMP1 = 32'd5;
            TMRCMP2 = 32'd2;
            TMREN = 1'b1;


            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Timer Disabled (TMREN=0)", test_num);
            reset_dut();
            PRE = 32'd0;
            TMRCMP1 = 32'd10;
            TMRCMP2 = 32'd2;
            TMREN = 1'b0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Early PWM Trigger", test_num);
            reset_dut();
            PRE = 32'd0;
            TMRCMP1 = 32'd20;
            TMRCMP2 = 32'd2;
            TMREN = 1'b1;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_pwm;
        begin
            if (expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pwm=%b",
                         pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm=%b",
                         expected_pwm);
                $display("  Got:      pwm=%b",
                         pwm);
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
        $dumpvars(0,PRE, TMRCMP1, TMRCMP2, TMREN, clk, rst, pwm);
    end

endmodule
