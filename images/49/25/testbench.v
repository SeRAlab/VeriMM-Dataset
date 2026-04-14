`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State (Seed)");
            reset = 1;
            #10;
            reset = 0;
            #2;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State after 1 clock cycle");
            reset_dut();



            #1;




            check_outputs(32'h00000003);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: State after 5 clock cycles");
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000036);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State after 10 clock cycles");
            reset_dut();
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h000006DB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State after 21 clock cycles");
            reset_dut();
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h006DB36D);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State after 22 clock cycles (Feedback includes bit 21)");
            reset_dut();
            repeat(21) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00DB66DB);
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
        input [31:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clk, reset, data);
    end

endmodule
