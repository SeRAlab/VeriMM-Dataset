`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] alpha;
    reg clock;
    reg [23:0] data;
    wire [23:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alpha(alpha),
        .clock(clock),
        .data(data),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            alpha = 0;
            data = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 24'hAABBCC;
            alpha = 9'h100;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Unity Gain (Alpha=256)", test_num);
            #1;

            check_outputs(24'hAABBCC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 24'hFF8040;
            alpha = 9'h080;
            @(posedge clock);
            #1;

            $display("Testcase %03d: Half Intensity (Alpha=128)", test_num);
            #1;

            check_outputs(24'h7F4020);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 24'hFFFFFF;
            alpha = 9'h000;
            @(posedge clock);
            #1;
            $display("Testcase %03d: Zero Intensity (Alpha=0)", test_num);
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 24'h00FF00;
            alpha = 9'h040;
            @(posedge clock);
            #1;

            $display("Testcase %03d: Quarter Intensity Green", test_num);
            #1;

            check_outputs(24'h003F00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 24'h808080;
            alpha = 9'h1FF;
            @(posedge clock);
            #1;



            $display("Testcase %03d: Max 9-bit Alpha (511)", test_num);
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 24'h123456;
            alpha = 9'h0C0;
            @(posedge clock);
            #1;



            $display("Testcase %03d: Random Mixed Values", test_num);
            #1;

            check_outputs(24'h0D2740);
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
        input [23:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,alpha, clock, data, data_out);
    end

endmodule
