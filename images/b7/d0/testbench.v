`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] ins_in;
    reg [31:0] pc_in;
    reg reset;
    reg stop;
    wire [31:0] ins_d;
    wire [31:0] pc_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ins_in(ins_in),
        .pc_in(pc_in),
        .reset(reset),
        .stop(stop),
        .ins_d(ins_d),
        .pc_d(pc_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stop = 0;
            ins_in = 0;
            pc_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ins_in = 32'h12345678;
            pc_in  = 32'h00001000;
            stop   = 0;
            reset  = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'h00001000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ins_in = 32'hABCD_EF01;
            pc_in  = 32'hFFFF_0000;
            stop   = 0;
            reset  = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD_EF01, 32'hFFFF_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ins_in = 32'hCAFE_BABE;
            pc_in  = 32'h0000_2000;
            stop   = 1;
            reset  = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ins_in = 32'hDEAD_BEEF;
            pc_in  = 32'h0000_3000;
            stop   = 0;
            reset  = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ins_in = 32'h5555_AAAA;
            pc_in  = 32'h4444_3333;
            stop   = 1;
            reset  = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ins_in = 32'hFFFF_FFFF;
            pc_in  = 32'hFFFF_FFFF;
            stop   = 0;
            reset  = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
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
        input [31:0] expected_ins_d;
        input [31:0] expected_pc_d;
        begin
            if (expected_ins_d === (expected_ins_d ^ ins_d ^ expected_ins_d) &&
                expected_pc_d === (expected_pc_d ^ pc_d ^ expected_pc_d)) begin
                $display("PASS");
                $display("  Outputs: ins_d=%h, pc_d=%h",
                         ins_d, pc_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ins_d=%h, pc_d=%h",
                         expected_ins_d, expected_pc_d);
                $display("  Got:      ins_d=%h, pc_d=%h",
                         ins_d, pc_d);
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
        $dumpvars(0,clk, ins_in, pc_in, reset, stop, ins_d, pc_d);
    end

endmodule
