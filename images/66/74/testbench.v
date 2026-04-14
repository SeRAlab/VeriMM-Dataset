`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [31:0] data_i;
    reg pull_i;
    reg push_i;
    reg rst_i;
    wire [31:0] data_o;
    wire empty_o;
    wire full_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .data_i(data_i),
        .pull_i(pull_i),
        .push_i(push_i),
        .rst_i(rst_i),
        .data_o(data_o),
        .empty_o(empty_o),
        .full_o(full_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            push_i = 0;
            pull_i = 0;
            data_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            repeat(1) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'hX, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_i = 32'hDEADBEEF;
            push_i = 1;
            @(posedge clk_i);
            push_i = 0;

            #1;


            check_outputs(32'hDEADBEEF, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_i = 32'h12345678;
            push_i = 1;
            @(posedge clk_i);
            push_i = 0;

            pull_i = 1;
            @(posedge clk_i);
            pull_i = 0;

            #1;


            check_outputs(32'hX, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            for (i = 1; i <= 16; i = i + 1) begin
                data_i = i;
                push_i = 1;
                @(posedge clk_i);
            end
            push_i = 0;

            #1;


            check_outputs(32'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            for (i = 1; i <= 16; i = i + 1) begin
                data_i = i;
                push_i = 1;
                @(posedge clk_i);
            end

            data_i = 32'hFFFFFFFF;
            push_i = 1;
            @(posedge clk_i);
            push_i = 0;

            #1;


            check_outputs(32'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            for (i = 1; i <= 16; i = i + 1) begin
                data_i = i;
                push_i = 1;
                @(posedge clk_i);
            end
            push_i = 0;

            pull_i = 1;
            repeat(16) @(posedge clk_i);
            pull_i = 0;

            #1;


            check_outputs(32'hX, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            for (i = 1; i <= 10; i = i + 1) begin
                data_i = i;
                push_i = 1; @(posedge clk_i);
            end
            push_i = 0;
            pull_i = 1;
            repeat(10) @(posedge clk_i);
            pull_i = 0;


            for (i = 100; i < 110; i = i + 1) begin
                data_i = i;
                push_i = 1; @(posedge clk_i);
            end
            push_i = 0;

            #1;


            check_outputs(32'd100, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            pull_i = 1;
            repeat(3) @(posedge clk_i);
            pull_i = 0;

            #1;


            check_outputs(32'hX, 1'b1, 1'b0);
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
        input [31:0] expected_data_o;
        input expected_empty_o;
        input expected_full_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_empty_o === (expected_empty_o ^ empty_o ^ expected_empty_o) &&
                expected_full_o === (expected_full_o ^ full_o ^ expected_full_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, empty_o=%b, full_o=%b",
                         data_o, empty_o, full_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, empty_o=%b, full_o=%b",
                         expected_data_o, expected_empty_o, expected_full_o);
                $display("  Got:      data_o=%h, empty_o=%b, full_o=%b",
                         data_o, empty_o, full_o);
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
        $dumpvars(0,clk_i, data_i, pull_i, push_i, rst_i, data_o, empty_o, full_o);
    end

endmodule
