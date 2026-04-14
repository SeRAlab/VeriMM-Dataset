`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] val_a;
    reg [7:0] val_b;
    wire [3:0] distance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .val_a(val_a),
        .val_b(val_b),
        .distance(distance)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        val_a = 8'h0;
        val_b = 8'h0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        val_a = 8'hAA;
        val_b = 8'hAA;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        val_a = 8'hFF;
        val_b = 8'h00;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        val_a = 8'b00000001;
        val_b = 8'b00000000;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        val_a = 8'h55;
        val_b = 8'hAA;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        val_a = 8'hF0;
        val_b = 8'h00;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        val_a = 8'hC0;
        val_b = 8'h30;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        val_a = 8'b10000001;
        val_b = 8'b01000010;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        val_a = 8'hFF;
        val_b = 8'hFE;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'd1);
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
        input [3:0] expected_distance;
        begin
            if (expected_distance === (expected_distance ^ distance ^ expected_distance)) begin
                $display("PASS");
                $display("  Outputs: distance=%h",
                         distance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance=%h",
                         expected_distance);
                $display("  Got:      distance=%h",
                         distance);
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
        $dumpvars(0,clock, val_a, val_b, distance);
    end

endmodule
