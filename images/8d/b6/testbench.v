`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg push_in;
    reg reset;
    wire [31:0] column;
    wire push_out;
    wire [31:0] row;
    wire [63:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .push_in(push_in),
        .reset(reset),
        .column(column),
        .push_out(push_out),
        .row(row),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            push_in = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 16-packet Ingestion", test_num);
            reset_dut();


            for (i = 0; i < 14; i = i + 1) begin
                @(negedge clk);
                data = i;
                push_in = 1;
            end


            @(negedge clk);
            data = {32'hAAAA_AAAA, 32'hBBBB_BBBB};
            push_in = 1;


            @(negedge clk);
            data = 64'hFEDC_BA98_7654_3210;
            push_in = 1;


            @(negedge clk);
            push_in = 0;
            #1;

            check_outputs(32'hBBBB_BBBB, 1'b1, 32'hAAAA_AAAA, 64'hFEDC_BA98_7654_3210);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-stream", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                data = 64'hFFFF_FFFF_FFFF_FFFF;
                push_in = 1;
            end


            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;


            for (i = 0; i < 15; i = i + 1) begin
                @(negedge clk);
                data = (i == 14) ? {32'h1111_1111, 32'h2222_2222} : i;
                push_in = 1;
            end


            @(negedge clk);
            if (push_out !== 0) begin
                $display("FAIL: push_out asserted early after reset!");
            end


            data = 64'h0000_1111_2222_3333;
            push_in = 1;
            @(negedge clk);
            push_in = 0;

            #1;


            check_outputs(32'h2222_2222, 1'b1, 32'h1111_1111, 64'h0000_1111_2222_3333);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Intermittent push_in", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                if (i == 14) data = {32'hCCCC_CCCC, 32'hDDDD_DDDD};
                else if (i == 15) data = 64'hAAAA_5555_AAAA_5555;
                else data = i;

                push_in = 1;
                @(negedge clk);
                push_in = 0;
                repeat(2) @(negedge clk);
            end

            #1;


            check_outputs(32'hDDDD_DDDD, 1'b1, 32'hCCCC_CCCC, 64'hAAAA_5555_AAAA_5555);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Back-to-Back Sets", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                data = (i == 14) ? {32'h1, 32'h2} : (i == 15) ? 64'hA : i;
                push_in = 1;
            end


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                data = (i == 14) ? {32'h3, 32'h4} : (i == 15) ? 64'hB : i;
                push_in = 1;
            end

            @(negedge clk);
            push_in = 0;

            #1;


            check_outputs(32'h4, 1'b1, 32'h3, 64'hB);
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
        input [31:0] expected_column;
        input expected_push_out;
        input [31:0] expected_row;
        input [63:0] expected_value;
        begin
            if (expected_column === (expected_column ^ column ^ expected_column) &&
                expected_push_out === (expected_push_out ^ push_out ^ expected_push_out) &&
                expected_row === (expected_row ^ row ^ expected_row) &&
                expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: column=%h, push_out=%b, row=%h, value=%h",
                         column, push_out, row, value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: column=%h, push_out=%b, row=%h, value=%h",
                         expected_column, expected_push_out, expected_row, expected_value);
                $display("  Got:      column=%h, push_out=%b, row=%h, value=%h",
                         column, push_out, row, value);
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
        $dumpvars(0,clk, data, push_in, reset, column, push_out, row, value);
    end

endmodule
