`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst_n;
    wire fall_detect;
    wire led_fall;
    wire led_rise;
    wire rise_detect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .fall_detect(fall_detect),
        .led_fall(led_fall),
        .led_rise(led_rise),
        .rise_detect(rise_detect)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising Edge Detection (0 -> 1)", test_num);
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            data_in = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Falling Edge Detection (1 -> 0)", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            @(posedge clk);
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Higher bits change, LSB stable low", test_num);
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            data_in = 4'b1110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Higher bits change, LSB stable high", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            @(posedge clk);
            data_in = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse duration check (Stable High)", test_num);
            reset_dut();
            data_in = 4'b0000;
            @(posedge clk);
            data_in = 4'b0001;
            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse duration check (Stable Low)", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            @(posedge clk);
            data_in = 4'b0000;
            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid Toggling", test_num);
            reset_dut();
            data_in = 4'b0001;
            @(posedge clk);
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0, 0);
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
        input expected_fall_detect;
        input expected_led_fall;
        input expected_led_rise;
        input expected_rise_detect;
        begin
            if (expected_fall_detect === (expected_fall_detect ^ fall_detect ^ expected_fall_detect) &&
                expected_led_fall === (expected_led_fall ^ led_fall ^ expected_led_fall) &&
                expected_led_rise === (expected_led_rise ^ led_rise ^ expected_led_rise) &&
                expected_rise_detect === (expected_rise_detect ^ rise_detect ^ expected_rise_detect)) begin
                $display("PASS");
                $display("  Outputs: fall_detect=%b, led_fall=%b, led_rise=%b, rise_detect=%b",
                         fall_detect, led_fall, led_rise, rise_detect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fall_detect=%b, led_fall=%b, led_rise=%b, rise_detect=%b",
                         expected_fall_detect, expected_led_fall, expected_led_rise, expected_rise_detect);
                $display("  Got:      fall_detect=%b, led_fall=%b, led_rise=%b, rise_detect=%b",
                         fall_detect, led_fall, led_rise, rise_detect);
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
        $dumpvars(0,clk, data_in, rst_n, fall_detect, led_fall, led_rise, rise_detect);
    end

endmodule
