`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] read_value;
    reg read_value_reg_en;
    reg reset;
    reg [3:0] write_value;
    wire led_fail;
    wire led_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .read_value(read_value),
        .read_value_reg_en(read_value_reg_en),
        .reset(reset),
        .write_value(write_value),
        .led_fail(led_fail),
        .led_success(led_success)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            read_value = 0;
            read_value_reg_en = 0;
            write_value = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial state after reset (Match 0)", test_num);
            reset_dut();
            write_value = 4'b0000;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Store value and verify Success signal", test_num);
            reset_dut();
            read_value = 4'hA;
            read_value_reg_en = 1;
            @(posedge clock);
            #1;
            read_value_reg_en = 0;
            write_value = 4'hA;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Store value and verify Fail signal", test_num);
            reset_dut();
            read_value = 4'h5;
            read_value_reg_en = 1;
            @(posedge clock);
            #1;
            read_value_reg_en = 0;
            write_value = 4'hE;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Enable signal functionality (No update when low)", test_num);
            reset_dut();
            read_value = 4'hC;
            read_value_reg_en = 0;
            @(posedge clock);
            #1;
            write_value = 4'hC;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify mid-operation Reset", test_num);
            reset_dut();

            read_value = 4'hF;
            read_value_reg_en = 1;
            @(posedge clock);
            #1;

            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
            write_value = 4'h0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary match (4'hF)", test_num);
            reset_dut();
            read_value = 4'hF;
            read_value_reg_en = 1;
            @(posedge clock);
            #1;
            read_value_reg_en = 0;
            write_value = 4'hF;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_led_fail;
        input expected_led_success;
        begin
            if (expected_led_fail === (expected_led_fail ^ led_fail ^ expected_led_fail) &&
                expected_led_success === (expected_led_success ^ led_success ^ expected_led_success)) begin
                $display("PASS");
                $display("  Outputs: led_fail=%b, led_success=%b",
                         led_fail, led_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_fail=%b, led_success=%b",
                         expected_led_fail, expected_led_success);
                $display("  Got:      led_fail=%b, led_success=%b",
                         led_fail, led_success);
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
        $dumpvars(0,clock, read_value, read_value_reg_en, reset, write_value, led_fail, led_success);
    end

endmodule
