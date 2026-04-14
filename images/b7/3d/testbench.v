`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    reg [7:0] shiftData;
    reg shiftLeft;
    reg shiftRight;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .shiftData(shiftData),
        .shiftLeft(shiftLeft),
        .shiftRight(shiftRight),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            shiftLeft = 0;
            shiftRight = 0;
            shiftData = 8'h00;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Left Shift (Insert 1)", test_num);
            reset_dut();
            shiftLeft = 1;
            shiftData = 8'h01;
            @(posedge clock);
            #1;
            shiftLeft = 0;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple Left Shifts", test_num);
            reset_dut();
            shiftLeft = 1;
            shiftData = 8'h01; @(posedge clock);
            shiftData = 8'h01; @(posedge clock);
            shiftData = 8'h00; @(posedge clock);
            shiftData = 8'h01; @(posedge clock);
            #1;
            shiftLeft = 0;
            #1;

            check_outputs(8'h0D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single Right Shift (Insert 1)", test_num);
            reset_dut();
            shiftRight = 1;
            shiftData = 8'h80;
            @(posedge clock);
            #1;
            shiftRight = 0;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple Right Shifts", test_num);
            reset_dut();
            shiftRight = 1;
            shiftData = 8'h80; @(posedge clock);
            shiftData = 8'h80; @(posedge clock);
            shiftData = 8'h00; @(posedge clock);
            shiftData = 8'h80; @(posedge clock);
            #1;
            shiftRight = 0;
            #1;

            check_outputs(8'hB0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Bidirectional Shifting", test_num);
            reset_dut();

            shiftLeft = 1;
            shiftData = 8'h01; @(posedge clock);
            shiftData = 8'h01; @(posedge clock);
            shiftLeft = 0;

            shiftRight = 1;
            shiftData = 8'h00; @(posedge clock);
            shiftData = 8'h80; @(posedge clock);
            #1;
            shiftRight = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Hold Value (No Control Active)", test_num);
            reset_dut();

            shiftLeft = 1;
            shiftData = 8'h01; @(posedge clock);
            shiftData = 8'h01; @(posedge clock);
            shiftLeft = 0;

            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Shift Left 8 Times (Fill Register)", test_num);
            reset_dut();
            shiftLeft = 1;
            shiftData = 8'h01;
            repeat(8) @(posedge clock);
            #1;
            shiftLeft = 0;
            #1;

            check_outputs(8'hFF);
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
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_data;
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
        $dumpvars(0,clock, reset, shiftData, shiftLeft, shiftRight, data);
    end

endmodule
