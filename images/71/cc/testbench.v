`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] datapath_in;
    reg [11:0] instruction;
    wire [15:0] datapath_out;
    wire [2:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datapath_in(datapath_in),
        .instruction(instruction),
        .datapath_out(datapath_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instruction = 12'h000;
            datapath_in = 16'h0000;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            instruction = 12'h000;
            datapath_in = 16'h000A;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h000A, 3'b010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            instruction = 12'h000;
            datapath_in = 16'hFFFB;
            @(posedge clk);
            #2;

            instruction = 12'h100;
            datapath_in = 16'h0005;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 3'b100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            instruction = 12'h000;
            datapath_in = 16'h0005;
            @(posedge clk);
            #2;

            instruction = 12'h200;
            datapath_in = 16'h000A;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFB, 3'b001);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            instruction = 12'h000;
            datapath_in = 16'hFFFF;
            @(posedge clk);
            #2;

            instruction = 12'h500;
            datapath_in = 16'h0F0F;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hF0F0, 3'b001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            instruction = 12'h000;
            datapath_in = 16'h0001;
            @(posedge clk);
            #2;

            instruction = 12'h600;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0002, 3'b010);
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
        input [15:0] expected_datapath_out;
        input [2:0] expected_status;
        begin
            if (expected_datapath_out === (expected_datapath_out ^ datapath_out ^ expected_datapath_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: datapath_out=%h, status=%h",
                         datapath_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datapath_out=%h, status=%h",
                         expected_datapath_out, expected_status);
                $display("  Got:      datapath_out=%h, status=%h",
                         datapath_out, status);
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
        $dumpvars(0,clk, datapath_in, instruction, datapath_out, status);
    end

endmodule
