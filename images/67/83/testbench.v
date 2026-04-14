`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg reset;
    wire [31:0] data_return_cpu;
    wire [31:0] led_lights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_return_cpu(data_return_cpu),
        .led_lights(led_lights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            data_in = 32'h0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h11111111, 32'hEEEEEEEE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Data Update with Enable", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            data_in = 32'hAAAAAAAA;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Data Stay when Enable is LOW", test_num);
            reset_dut();
            @(posedge clk);
            enable = 0;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);

            #1;


            check_outputs(32'h11111111, 32'hEEEEEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Consecutive Updates", test_num);
            reset_dut();
            enable = 1;
            data_in = 32'h12345678;
            @(posedge clk);
            data_in = 32'h87654321;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(32'h87654321, ~32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();
            enable = 1;
            data_in = 32'h00000000;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: All Ones Input", test_num);
            reset_dut();
            enable = 1;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            enable = 0;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Reset Priority", test_num);
            reset_dut();

            enable = 1;
            data_in = 32'hABCDEF01;
            @(posedge clk);

            reset = 1;
            data_in = 32'h00000000;
            @(posedge clk);
            reset = 0;
            enable = 0;

            #1;


            check_outputs(32'h11111111, 32'hEEEEEEEE);
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
        input [31:0] expected_data_return_cpu;
        input [31:0] expected_led_lights;
        begin
            if (expected_data_return_cpu === (expected_data_return_cpu ^ data_return_cpu ^ expected_data_return_cpu) &&
                expected_led_lights === (expected_led_lights ^ led_lights ^ expected_led_lights)) begin
                $display("PASS");
                $display("  Outputs: data_return_cpu=%h, led_lights=%h",
                         data_return_cpu, led_lights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_return_cpu=%h, led_lights=%h",
                         expected_data_return_cpu, expected_led_lights);
                $display("  Got:      data_return_cpu=%h, led_lights=%h",
                         data_return_cpu, led_lights);
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
        $dumpvars(0,clk, data_in, enable, reset, data_return_cpu, led_lights);
    end

endmodule
