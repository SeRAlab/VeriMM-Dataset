`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] adc_input;
    reg clk;
    reg reset;
    wire [11:0] lower_output;
    wire [11:0] upper_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .reset(reset),
        .lower_output(lower_output),
        .upper_output(upper_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adc_input = 24'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            adc_input = 24'hABCDEF;
            @(posedge clk);
            #2;
            $display("Test Case 001: Input 0xABCDEF");
            #1;

            check_outputs(12'hDEF, 12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            adc_input = 24'h123456;
            @(posedge clk);
            #2;
            $display("Test Case 002: Input 0x123456");
            #1;

            check_outputs(12'h456, 12'h123);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            adc_input = 24'hFFFFFF;
            @(posedge clk);
            #2;
            $display("Test Case 003: Input 0xFFFFFF");
            #1;

            check_outputs(12'hFFF, 12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            adc_input = 24'h000000;
            @(posedge clk);
            #2;
            $display("Test Case 004: Input 0x000000");
            #1;

            check_outputs(12'h000, 12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            adc_input = 24'h555AAA;
            @(posedge clk);
            #2;
            $display("Test Case 005: Input 0x555AAA");
            #1;

            check_outputs(12'hAAA, 12'h555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [11:0] expected_lower_output;
        input [11:0] expected_upper_output;
        begin
            if (expected_lower_output === (expected_lower_output ^ lower_output ^ expected_lower_output) &&
                expected_upper_output === (expected_upper_output ^ upper_output ^ expected_upper_output)) begin
                $display("PASS");
                $display("  Outputs: lower_output=%h, upper_output=%h",
                         lower_output, upper_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_output=%h, upper_output=%h",
                         expected_lower_output, expected_upper_output);
                $display("  Got:      lower_output=%h, upper_output=%h",
                         lower_output, upper_output);
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
        $dumpvars(0,adc_input, clk, reset, lower_output, upper_output);
    end

endmodule
