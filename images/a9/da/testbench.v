`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] IR_in;
    reg IR_ld;
    reg clk;
    reg reset;
    wire [31:0] IR_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR_in(IR_in),
        .IR_ld(IR_ld),
        .clk(clk),
        .reset(reset),
        .IR_out(IR_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            IR_in = 32'h0;
            IR_ld = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset behavior");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Load (0x12345678)");
            reset_dut();
            IR_in = 32'h12345678;
            IR_ld = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Load Disable Check");
            reset_dut();


            IR_in = 32'hAAAAAAAA;
            IR_ld = 1;
            @(posedge clk);
            #1;


            IR_in = 32'hBBBBBBBB;
            IR_ld = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Loading All Ones (0xFFFFFFFF)");
            reset_dut();
            IR_in = 32'hFFFFFFFF;
            IR_ld = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Sequential Loading");
            reset_dut();

            IR_ld = 1;
            IR_in = 32'hCAFEFACE;
            @(posedge clk);
            #1;

            IR_in = 32'hDEADBEEF;
            @(posedge clk);
            #1;

            IR_in = 32'h0000C0DE;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000C0DE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset priority over Load");
            reset_dut();


            @(negedge clk);
            reset = 1;
            IR_ld = 1;
            IR_in = 32'h5555AAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);


            @(negedge clk);
            reset = 0;
            IR_ld = 0;
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
        input [31:0] expected_IR_out;
        begin
            if (expected_IR_out === (expected_IR_out ^ IR_out ^ expected_IR_out)) begin
                $display("PASS");
                $display("  Outputs: IR_out=%h",
                         IR_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IR_out=%h",
                         expected_IR_out);
                $display("  Got:      IR_out=%h",
                         IR_out);
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
        $dumpvars(0,IR_in, IR_ld, clk, reset, IR_out);
    end

endmodule
