`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data;
    reg reset;
    reg [1:0] sel;
    wire LSBout;
    wire MSBout;
    wire [3:0] qout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .reset(reset),
        .sel(sel),
        .LSBout(LSBout),
        .MSBout(MSBout),
        .qout(qout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;
            data = 4'b0000;
            sel = 0;
            @(posedge clock);
            #2 reset = 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Load and Hold...");
            reset_dut();
            @(negedge clock);
            data = 4'b1011; sel = 3;
            @(negedge clock);
            sel = 0;
            @(negedge clock);
            #1;

            check_outputs(1, 1, 4'b1011);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Rotate Left...");
            reset_dut();
            @(negedge clock);
            data = 4'b1100; sel = 3;
            @(negedge clock);
            sel = 1;
            @(negedge clock);
            #1;

            check_outputs(1, 1, 4'b1001);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Rotate Right...");
            reset_dut();
            @(negedge clock);
            data = 4'b1100; sel = 3;
            @(negedge clock);
            sel = 2;
            @(negedge clock);
            #1;

            check_outputs(0, 0, 4'b0110);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset mid-operation...");
            reset_dut();
            @(negedge clock);
            data = 4'b1111; sel = 3;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
            #1;

            check_outputs(0, 0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Full Left Rotation...");
            reset_dut();
            @(negedge clock);
            data = 4'b1000; sel = 3;
            @(negedge clock);
            sel = 1;
            repeat(4) @(negedge clock);
            #1;

            check_outputs(0, 1, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Alternating Rotations...");
            reset_dut();
            @(negedge clock);
            data = 4'b1010; sel = 3;
            @(negedge clock);
            sel = 1;
            @(negedge clock);
            sel = 2;
            @(negedge clock);
            #1;

            check_outputs(0, 1, 4'b1010);
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
        input expected_LSBout;
        input expected_MSBout;
        input [3:0] expected_qout;
        begin
            if (expected_LSBout === (expected_LSBout ^ LSBout ^ expected_LSBout) &&
                expected_MSBout === (expected_MSBout ^ MSBout ^ expected_MSBout) &&
                expected_qout === (expected_qout ^ qout ^ expected_qout)) begin
                $display("PASS");
                $display("  Outputs: LSBout=%b, MSBout=%b, qout=%h",
                         LSBout, MSBout, qout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LSBout=%b, MSBout=%b, qout=%h",
                         expected_LSBout, expected_MSBout, expected_qout);
                $display("  Got:      LSBout=%b, MSBout=%b, qout=%h",
                         LSBout, MSBout, qout);
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
        $dumpvars(0,clock, data, reset, sel, LSBout, MSBout, qout);
    end

endmodule
