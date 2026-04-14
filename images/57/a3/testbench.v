`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] control;
    reg [15:0] src_adc_data;
    reg src_adc_enable;
    reg src_adc_valid;
    wire [15:0] dst_adc_data;
    wire dst_adc_enable;
    wire dst_adc_valid;
    wire [31:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .src_adc_data(src_adc_data),
        .src_adc_enable(src_adc_enable),
        .src_adc_valid(src_adc_valid),
        .dst_adc_data(dst_adc_data),
        .dst_adc_enable(dst_adc_enable),
        .dst_adc_valid(dst_adc_valid),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            src_adc_data = 16'h0;
            src_adc_enable = 1'b0;
            src_adc_valid = 1'b0;
            control = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);
            reset_dut();


            src_adc_data = 16'hABCD;
            src_adc_enable = 1'b1;
            src_adc_valid = 1'b1;
            control = 32'h0;


            @(posedge clk);
            #2;



            #1;




            check_outputs(16'hABCD, 1'b1, 1'b1, status);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Transfer with Enable Low", test_num);
            reset_dut();

            src_adc_data = 16'h1234;
            src_adc_enable = 1'b0;
            src_adc_valid = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1234, 1'b0, 1'b1, status);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Transfer with Valid Low", test_num);
            reset_dut();

            src_adc_data = 16'hFFFF;
            src_adc_enable = 1'b1;
            src_adc_valid = 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 1'b1, 1'b0, status);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Changes", test_num);
            reset_dut();


            src_adc_data = 16'hAAAA;
            src_adc_enable = 1'b1;
            src_adc_valid = 1'b1;
            @(posedge clk);


            src_adc_data = 16'h5555;
            src_adc_enable = 1'b1;
            src_adc_valid = 1'b1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h5555, 1'b1, 1'b1, status);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Signal and Status Check", test_num);
            reset_dut();

            src_adc_data = 16'hBEEF;
            src_adc_enable = 1'b1;
            src_adc_valid = 1'b1;
            control = 32'hDEADBEEF;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hBEEF, 1'b1, 1'b1, status);
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
        input [15:0] expected_dst_adc_data;
        input expected_dst_adc_enable;
        input expected_dst_adc_valid;
        input [31:0] expected_status;
        begin
            if (expected_dst_adc_data === (expected_dst_adc_data ^ dst_adc_data ^ expected_dst_adc_data) &&
                expected_dst_adc_enable === (expected_dst_adc_enable ^ dst_adc_enable ^ expected_dst_adc_enable) &&
                expected_dst_adc_valid === (expected_dst_adc_valid ^ dst_adc_valid ^ expected_dst_adc_valid) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: dst_adc_data=%h, dst_adc_enable=%b, dst_adc_valid=%b, status=%h",
                         dst_adc_data, dst_adc_enable, dst_adc_valid, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst_adc_data=%h, dst_adc_enable=%b, dst_adc_valid=%b, status=%h",
                         expected_dst_adc_data, expected_dst_adc_enable, expected_dst_adc_valid, expected_status);
                $display("  Got:      dst_adc_data=%h, dst_adc_enable=%b, dst_adc_valid=%b, status=%h",
                         dst_adc_data, dst_adc_enable, dst_adc_valid, status);
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
        $dumpvars(0,clk, control, src_adc_data, src_adc_enable, src_adc_valid, dst_adc_data, dst_adc_enable, dst_adc_valid, status);
    end

endmodule
