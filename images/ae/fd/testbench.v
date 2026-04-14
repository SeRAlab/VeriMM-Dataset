`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] out_data;
    reg out_done;
    reg out_valid;
    reg rst;
    wire [15:0] data_o;
    wire done_o;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .out_data(out_data),
        .out_done(out_done),
        .out_valid(out_valid),
        .rst(rst),
        .data_o(data_o),
        .done_o(done_o),
        .valid_o(valid_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            out_data = 8'h0;
            out_valid = 0;
            out_done = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 2-byte capture", test_num);
            reset_dut();


            out_valid = 1;
            out_data = 8'hDE;
            @(posedge clk);


            out_valid = 1;
            out_data = 8'hAD;
            @(posedge clk);


            out_valid = 0;
            #1;
            #1;

            check_outputs(16'hDEAD, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Capture with out_valid gaps", test_num);
            reset_dut();


            out_valid = 1;
            out_data = 8'h12;
            @(posedge clk);


            out_valid = 0;
            out_data = 8'hFF;
            @(posedge clk);


            out_valid = 1;
            out_data = 8'h34;
            @(posedge clk);

            out_valid = 0;
            #1;
            #1;

            check_outputs(16'h1234, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify out_done logic", test_num);
            reset_dut();

            out_done = 1;
            @(posedge clk);
            out_done = 0;
            #1;

            #1;


            check_outputs(16'h0000, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous streaming", test_num);
            reset_dut();


            out_valid = 1; out_data = 8'hAA; @(posedge clk);
            out_valid = 1; out_data = 8'hBB; @(posedge clk);


            out_valid = 1; out_data = 8'hCC; @(posedge clk);
            out_valid = 1; out_data = 8'hDD; @(posedge clk);

            out_valid = 0;
            #1;

            #1;


            check_outputs(16'hCCDD, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-capture", test_num);
            reset_dut();


            out_valid = 1;
            out_data = 8'h55;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            out_valid = 1; out_data = 8'hAA; @(posedge clk);
            out_valid = 1; out_data = 8'hBB; @(posedge clk);

            out_valid = 0;
            #1;

            #1;


            check_outputs(16'hAABB, 0, 1);
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
        input [15:0] expected_data_o;
        input expected_done_o;
        input expected_valid_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_done_o === (expected_done_o ^ done_o ^ expected_done_o) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, done_o=%b, valid_o=%b",
                         data_o, done_o, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, done_o=%b, valid_o=%b",
                         expected_data_o, expected_done_o, expected_valid_o);
                $display("  Got:      data_o=%h, done_o=%b, valid_o=%b",
                         data_o, done_o, valid_o);
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
        $dumpvars(0,clk, out_data, out_done, out_valid, rst, data_o, done_o, valid_o);
    end

endmodule
