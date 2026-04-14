`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] analog_input;
    reg clk;
    reg reset;
    reg start;
    wire [23:0] digital_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .analog_input(analog_input),
        .clk(clk),
        .reset(reset),
        .start(start),
        .digital_output(digital_output),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            analog_input = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Zero Scale (0x000000)", test_num);
            reset_dut();

            analog_input = 24'h000000;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(valid === 1'b1);
            #1;
            #1;

            check_outputs(24'h000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Full Scale (0xFFFFFF)", test_num);
            reset_dut();

            analog_input = 24'hFFFFFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1'b1);
            #1;
            #1;

            check_outputs(24'hFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Mid Scale (0x800000)", test_num);
            reset_dut();

            analog_input = 24'h800000;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1'b1);
            #1;
            #1;

            check_outputs(24'h800000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Arbitrary Value (0xA5A5A5)", test_num);
            reset_dut();

            analog_input = 24'hA5A5A5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1'b1);
            #1;
            #1;

            check_outputs(24'hA5A5A5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Arbitrary Value (0x123456)", test_num);
            reset_dut();

            analog_input = 24'h123456;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(valid === 1'b1);
            #1;
            #1;

            check_outputs(24'h123456, 1'b1);
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
        input [23:0] expected_digital_output;
        input expected_valid;
        begin
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h, valid=%b",
                         digital_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h, valid=%b",
                         expected_digital_output, expected_valid);
                $display("  Got:      digital_output=%h, valid=%b",
                         digital_output, valid);
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
        $dumpvars(0,analog_input, clk, reset, start, digital_output, valid);
    end

endmodule
