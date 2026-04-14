`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Rst;
    reg [3:0] in;
    wire ClkOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Rst(Rst),
        .in(in),
        .ClkOut(ClkOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            in = 4'b0000;
            @(negedge Clk);
            Rst = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            $display("Testcase 001: Reset State");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in = 4'b0001;
            @(posedge Clk);
            #2;
            $display("Testcase 002: Div-by-2, First Toggle High");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 4'b0001;
            @(posedge Clk);
            @(posedge Clk);
            #2;
            $display("Testcase 003: Div-by-2, Second Toggle Low");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 4'b0010;
            @(posedge Clk);
            @(posedge Clk);
            #2;
            $display("Testcase 004: Div-by-4, Toggle High after 2 cycles");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in = 4'b0100;
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            #2;
            $display("Testcase 005: Div-by-6, Toggle High after 3 cycles");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in = 4'b1000;
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            @(posedge Clk);
            #2;
            $display("Testcase 006: Div-by-8, Toggle High after 4 cycles");
            #1;

            check_outputs(1'b1);
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
        input expected_ClkOut;
        begin
            if (expected_ClkOut === (expected_ClkOut ^ ClkOut ^ expected_ClkOut)) begin
                $display("PASS");
                $display("  Outputs: ClkOut=%b",
                         ClkOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ClkOut=%b",
                         expected_ClkOut);
                $display("  Got:      ClkOut=%b",
                         ClkOut);
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
        $dumpvars(0,Clk, Rst, in, ClkOut);
    end

endmodule
