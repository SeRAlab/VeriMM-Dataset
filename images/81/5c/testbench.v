`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] control;
    reg dst_dac_enable;
    reg dst_dac_valid;
    reg [15:0] src_dac_data;
    wire [15:0] dst_dac_data;
    wire src_dac_enable;
    wire src_dac_valid;
    wire [31:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .dst_dac_enable(dst_dac_enable),
        .dst_dac_valid(dst_dac_valid),
        .src_dac_data(src_dac_data),
        .dst_dac_data(dst_dac_data),
        .src_dac_enable(src_dac_enable),
        .src_dac_valid(src_dac_valid),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk = 0;
            control = 32'h0;
            dst_dac_enable = 0;
            dst_dac_valid = 0;
            src_dac_data = 16'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Data Transfer", test_num);
            reset_dut();

            control = 32'hA5A5A5A5;
            dst_dac_enable = 1'b1;
            dst_dac_valid = 1'b1;
            src_dac_data = 16'h1234;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h1234, 1'b1, 1'b1, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable Status Check", test_num);
            reset_dut();

            control = 32'h11223344;
            dst_dac_enable = 1'b0;
            dst_dac_valid = 1'b1;
            src_dac_data = 16'hABCD;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hABCD, 1'b0, 1'b1, 32'h11223344);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid State Propagation", test_num);
            reset_dut();

            control = 32'hFFFFFFFF;
            dst_dac_enable = 1'b1;
            dst_dac_valid = 1'b0;
            src_dac_data = 16'hDEAD;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hDEAD, 1'b1, 1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Data Updates", test_num);
            reset_dut();

            control = 32'h0000CAFE;
            dst_dac_enable = 1'b1;
            dst_dac_valid = 1'b1;

            src_dac_data = 16'h1111;
            @(posedge clk);
            #2;

            src_dac_data = 16'h2222;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h2222, 1'b1, 1'b1, 32'h0000CAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values", test_num);
            reset_dut();

            control = 32'h80000001;
            dst_dac_enable = 1'b1;
            dst_dac_valid = 1'b1;
            src_dac_data = 16'hFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 1'b1, 1'b1, 32'h80000001);
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
        input [15:0] expected_dst_dac_data;
        input expected_src_dac_enable;
        input expected_src_dac_valid;
        input [31:0] expected_status;
        begin
            if (expected_dst_dac_data === (expected_dst_dac_data ^ dst_dac_data ^ expected_dst_dac_data) &&
                expected_src_dac_enable === (expected_src_dac_enable ^ src_dac_enable ^ expected_src_dac_enable) &&
                expected_src_dac_valid === (expected_src_dac_valid ^ src_dac_valid ^ expected_src_dac_valid) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: dst_dac_data=%h, src_dac_enable=%b, src_dac_valid=%b, status=%h",
                         dst_dac_data, src_dac_enable, src_dac_valid, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst_dac_data=%h, src_dac_enable=%b, src_dac_valid=%b, status=%h",
                         expected_dst_dac_data, expected_src_dac_enable, expected_src_dac_valid, expected_status);
                $display("  Got:      dst_dac_data=%h, src_dac_enable=%b, src_dac_valid=%b, status=%h",
                         dst_dac_data, src_dac_enable, src_dac_valid, status);
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
        $dumpvars(0,clk, control, dst_dac_enable, dst_dac_valid, src_dac_data, dst_dac_data, src_dac_enable, src_dac_valid, status);
    end

endmodule
