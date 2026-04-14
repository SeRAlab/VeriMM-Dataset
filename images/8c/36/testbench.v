`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [7:0] data_i;
    reg flush_i;
    reg pop_i;
    reg push_i;
    reg rst_i;
    wire [7:0] data_o;
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
        .flush_i(flush_i),
        .pop_i(pop_i),
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
            pop_i = 0;
            flush_i = 0;
            data_i = 0;
            repeat(2) @(posedge clk_i);
            #1 rst_i = 0;
            repeat(1) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write Operation");
            reset_dut();
            @(negedge clk_i);
            push_i = 1;
            data_i = 8'hA5;
            @(negedge clk_i);
            push_i = 0;
            data_i = 0;

            #1;


            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write then Pop");
            reset_dut();
            @(negedge clk_i);
            push_i = 1;
            data_i = 8'h5A;
            @(negedge clk_i);
            push_i = 0;
            pop_i = 1;
            @(negedge clk_i);
            pop_i = 0;


            #1;



            check_outputs(data_o, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: FIFO Logic Ordering");
            reset_dut();
            @(negedge clk_i);
            push_i = 1; data_i = 8'h11;
            @(negedge clk_i);
            push_i = 1; data_i = 8'h22;
            @(negedge clk_i);
            push_i = 0; pop_i = 1;
            @(negedge clk_i);
            pop_i = 0;

            #1;


            check_outputs(8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Flush Operation");
            reset_dut();
            @(negedge clk_i);
            push_i = 1; data_i = 8'hFF;
            @(negedge clk_i);
            push_i = 1; data_i = 8'hEE;
            @(negedge clk_i);
            push_i = 0;
            flush_i = 1;
            @(negedge clk_i);
            flush_i = 0;

            #1;


            check_outputs(data_o, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Fill to Full");
            reset_dut();
            @(negedge clk_i);
            push_i = 1;
            for (i = 0; i < 32; i = i + 1) begin
                data_i = i[7:0];
                @(negedge clk_i);
                if (full_o) break;
            end
            push_i = 0;

            #1;


            check_outputs(data_o, 1'b0, 1'b1);
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
        input [7:0] expected_data_o;
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
        $dumpvars(0,clk_i, data_i, flush_i, pop_i, push_i, rst_i, data_o, empty_o, full_o);
    end

endmodule
