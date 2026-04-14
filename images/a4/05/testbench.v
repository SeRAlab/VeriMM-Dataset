`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [15:0] io_fifo_data;
    reg io_fifo_valid;
    reg io_pe0_ready;
    reg io_pe1_ready;
    reg reset;
    wire io_fifo_ready;
    wire [15:0] io_pe0_data;
    wire io_pe0_valid;
    wire [15:0] io_pe1_data;
    wire io_pe1_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_fifo_data(io_fifo_data),
        .io_fifo_valid(io_fifo_valid),
        .io_pe0_ready(io_pe0_ready),
        .io_pe1_ready(io_pe1_ready),
        .reset(reset),
        .io_fifo_ready(io_fifo_ready),
        .io_pe0_data(io_pe0_data),
        .io_pe0_valid(io_pe0_valid),
        .io_pe1_data(io_pe1_data),
        .io_pe1_valid(io_pe1_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset (PE0 target)", test_num);
            reset_dut();

            io_fifo_data = 16'hAAAA;
            io_fifo_valid = 1;
            io_pe0_ready = 1;
            io_pe1_ready = 1;

            #1;


            check_outputs(1'b1, 16'hAAAA, 1'b1, 16'hAAAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Switch to PE1 after PE0 transfer", test_num);
            reset_dut();

            io_fifo_data = 16'h1111;
            io_fifo_valid = 1;
            io_pe0_ready = 1;
            @(posedge clock);
            #1;

            io_fifo_data = 16'h2222;
            io_pe1_ready = 1;

            #1;


            check_outputs(1'b1, 16'h2222, 1'b0, 16'h2222, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Complete Round-robin cycle", test_num);
            reset_dut();

            io_fifo_valid = 1; io_pe0_ready = 1; io_fifo_data = 16'h1; @(posedge clock); #1;

            io_fifo_valid = 1; io_pe1_ready = 1; io_fifo_data = 16'h2; @(posedge clock); #1;

            io_fifo_data = 16'h3;
            io_pe0_ready = 1;
            #1;

            check_outputs(1'b1, 16'h3, 1'b1, 16'h3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: PE0 not ready when it is its turn", test_num);
            reset_dut();
            io_fifo_valid = 1;
            io_fifo_data = 16'hDEAD;
            io_pe0_ready = 0;
            io_pe1_ready = 1;


            #1;



            check_outputs(1'b0, 16'hDEAD, 1'b1, 16'hDEAD, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: FIFO not valid", test_num);
            reset_dut();
            io_fifo_valid = 0;
            io_fifo_data = 16'hBEEF;
            io_pe0_ready = 1;
            io_pe1_ready = 1;

            #1;


            check_outputs(1'b1, 16'hBEEF, 1'b0, 16'hBEEF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: PE1 not ready when it is its turn", test_num);
            reset_dut();

            io_fifo_valid = 1; io_pe0_ready = 1; io_fifo_data = 16'h1; @(posedge clock); #1;

            io_fifo_valid = 1;
            io_fifo_data = 16'hFEED;
            io_pe0_ready = 1;
            io_pe1_ready = 0;

            #1;


            check_outputs(1'b0, 16'hFEED, 1'b0, 16'hFEED, 1'b1);
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
        input expected_io_fifo_ready;
        input [15:0] expected_io_pe0_data;
        input expected_io_pe0_valid;
        input [15:0] expected_io_pe1_data;
        input expected_io_pe1_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_fifo_ready === (expected_io_fifo_ready ^ io_fifo_ready ^ expected_io_fifo_ready) &&
                expected_io_pe0_data === (expected_io_pe0_data ^ io_pe0_data ^ expected_io_pe0_data) &&
                expected_io_pe0_valid === (expected_io_pe0_valid ^ io_pe0_valid ^ expected_io_pe0_valid) &&
                expected_io_pe1_data === (expected_io_pe1_data ^ io_pe1_data ^ expected_io_pe1_data) &&
                expected_io_pe1_valid === (expected_io_pe1_valid ^ io_pe1_valid ^ expected_io_pe1_valid)) begin
                $display("PASS");
                $display("  Outputs: io_fifo_ready=%b, io_pe0_data=%h, io_pe0_valid=%b, io_pe1_data=%h, io_pe1_valid=%b",
                         io_fifo_ready, io_pe0_data, io_pe0_valid, io_pe1_data, io_pe1_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_fifo_ready=%b, io_pe0_data=%h, io_pe0_valid=%b, io_pe1_data=%h, io_pe1_valid=%b",
                         expected_io_fifo_ready, expected_io_pe0_data, expected_io_pe0_valid, expected_io_pe1_data, expected_io_pe1_valid);
                $display("  Got:      io_fifo_ready=%b, io_pe0_data=%h, io_pe0_valid=%b, io_pe1_data=%h, io_pe1_valid=%b",
                         io_fifo_ready, io_pe0_data, io_pe0_valid, io_pe1_data, io_pe1_valid);
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

endmodule
