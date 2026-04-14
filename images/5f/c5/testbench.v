`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_data;
    reg i_stall;
    reg i_valid;
    reg reset;
    wire [31:0] o_data;
    wire o_stall;
    wire o_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_data(i_data),
        .i_stall(i_stall),
        .i_valid(i_valid),
        .reset(reset),
        .o_data(o_data),
        .o_stall(o_stall),
        .o_valid(o_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            i_data = 0;
            i_stall = 0;
            i_valid = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Pass-through");
            test_num = test_num + 1;
            reset_dut();

            i_valid <= 1;
            i_data <= 32'hABCDEF01;
            i_stall <= 0;
            @(posedge clk);
            #1;
            i_valid <= 0;



            #1;




            check_outputs(32'hABCDEF01, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Downstream Backpressure");
            test_num = test_num + 1;
            reset_dut();

            i_valid <= 1;
            i_data <= 32'h5555AAAA;
            i_stall <= 1;
            @(posedge clk);
            #1;
            i_valid <= 0;


            #1;



            check_outputs(32'h5555AAAA, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Buffer Saturation");
            test_num = test_num + 1;
            reset_dut();

            i_stall <= 1;
            i_valid <= 1;
            i_data <= 32'h11111111;
            @(posedge clk);
            #1;
            i_data <= 32'h22222222;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h11111111, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Recover from Stall");
            test_num = test_num + 1;
            reset_dut();


            i_stall <= 1;
            i_valid <= 1;
            i_data <= 32'hCAFEFEED;
            @(posedge clk); #1;
            i_data <= 32'hBEEFCAFE;
            @(posedge clk); #1;


            i_valid <= 0;
            i_stall <= 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hBEEFCAFE, 1'b0, 1'b1);
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
        input [31:0] expected_o_data;
        input expected_o_stall;
        input expected_o_valid;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data) &&
                expected_o_stall === (expected_o_stall ^ o_stall ^ expected_o_stall) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h, o_stall=%b, o_valid=%b",
                         o_data, o_stall, o_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h, o_stall=%b, o_valid=%b",
                         expected_o_data, expected_o_stall, expected_o_valid);
                $display("  Got:      o_data=%h, o_stall=%b, o_valid=%b",
                         o_data, o_stall, o_valid);
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
        $dumpvars(0,clk, i_data, i_stall, i_valid, reset, o_data, o_stall, o_valid);
    end

endmodule
