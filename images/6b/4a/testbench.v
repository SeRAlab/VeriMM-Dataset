`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_i;
    reg pop_i;
    reg push_i;
    reg rst;
    wire [7:0] data_o;
    wire empty_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_i(data_i),
        .pop_i(pop_i),
        .push_i(push_i),
        .rst(rst),
        .data_o(data_o),
        .empty_o(empty_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push_i = 0;
            pop_i = 0;
            data_i = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Checking reset state...");
            reset_dut();


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Single push operation (0xAA)...");
            reset_dut();
            data_i = 8'hAA;
            push_i = 1;
            @(posedge clk);
            #1 push_i = 0;

            #1;


            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Push (0xBB) followed by Pop...");
            reset_dut();
            data_i = 8'hBB;
            push_i = 1;
            @(posedge clk);
            #1 push_i = 0;
            pop_i = 1;
            @(posedge clk);
            #1 pop_i = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Multiple pushes (0x11, 0x22, 0x33)...");
            reset_dut();
            data_i = 8'h11; push_i = 1; @(posedge clk);
            #1 data_i = 8'h22; push_i = 1; @(posedge clk);
            #1 data_i = 8'h33; push_i = 1; @(posedge clk);
            #1 push_i = 0;

            #1;


            check_outputs(8'h33, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Push 0x11, 0x22, then Pop once...");
            reset_dut();
            data_i = 8'h11; push_i = 1; @(posedge clk);
            #1 data_i = 8'h22; push_i = 1; @(posedge clk);
            #1 push_i = 0;
            pop_i = 1; @(posedge clk);
            #1 pop_i = 0;

            #1;


            check_outputs(8'h11, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Popping an empty stack...");
            reset_dut();
            pop_i = 1;
            @(posedge clk);
            #1 pop_i = 0;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Sequence: Push 0xCC, Push 0xDD, Pop, Push 0xEE...");
            reset_dut();
            data_i = 8'hCC; push_i = 1; @(posedge clk);
            #1 data_i = 8'hDD; push_i = 1; @(posedge clk);
            #1 push_i = 0; pop_i = 1; @(posedge clk);
            #1 pop_i = 0; data_i = 8'hEE; push_i = 1; @(posedge clk);
            #1 push_i = 0;

            #1;


            check_outputs(8'hEE, 1'b0);
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
        input [7:0] expected_data_o;
        input expected_empty_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_empty_o === (expected_empty_o ^ empty_o ^ expected_empty_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, empty_o=%b",
                         data_o, empty_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, empty_o=%b",
                         expected_data_o, expected_empty_o);
                $display("  Got:      data_o=%h, empty_o=%b",
                         data_o, empty_o);
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
        $dumpvars(0,clk, data_i, pop_i, push_i, rst, data_o, empty_o);
    end

endmodule
