`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg rst_n;
    wire no_pulse;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .rst_n(rst_n),
        .no_pulse(no_pulse),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset state check", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short pulse start (1 cycle)", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse mid-way (25 cycles)", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(25) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - 49 cycles", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(49) @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary hit - 50 cycles", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long pulse - 60 cycles", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse deassertion (a goes low at 10 cycles)", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(10) @(posedge clk);
            a <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse deassertion (a goes low at 55 cycles)", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(55) @(posedge clk);
            a <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset mid-pulse", test_num);
            reset_dut();
            @(posedge clk);
            a <= 1;
            repeat(20) @(posedge clk);
            rst_n <= 0;
            #5;
            #1;

            check_outputs(0, 0);
            #5 rst_n <= 1;
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
        testcase009();
        
        
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
        input expected_no_pulse;
        input expected_pulse;
        begin
            if (expected_no_pulse === (expected_no_pulse ^ no_pulse ^ expected_no_pulse) &&
                expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: no_pulse=%b, pulse=%b",
                         no_pulse, pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: no_pulse=%b, pulse=%b",
                         expected_no_pulse, expected_pulse);
                $display("  Got:      no_pulse=%b, pulse=%b",
                         no_pulse, pulse);
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
        $dumpvars(0,a, clk, rst_n, no_pulse, pulse);
    end

endmodule
