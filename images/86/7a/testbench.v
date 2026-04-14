`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Ar;
    reg [7:0] R;
    reg clock;
    reg [7:0] t;
    wire [7:0] Jr;
    wire [15:0] Jr_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ar(Ar),
        .R(R),
        .clock(clock),
        .t(t),
        .Jr(Jr),
        .Jr_temp(Jr_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        Ar = 0;
        R = 0;
        t = 1;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Normal recovery (R > Ar)", test_num);
        Ar = 8'd50;
        R  = 8'd100;
        t  = 8'd128;



        @(posedge clock);
        #2;
        #1;

        check_outputs(8'd149, 16'd99);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: R < Ar (Should reset output)", test_num);
        Ar = 8'd100;
        R  = 8'd50;
        t  = 8'd128;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'd0, 16'd0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: R == Ar (Boundary condition)", test_num);
        Ar = 8'd80;
        R  = 8'd80;
        t  = 8'd10;
        @(posedge clock);
        #2;
        #1;

        check_outputs(8'd0, 16'd0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Small t value calculation", test_num);
        Ar = 8'd10;
        R  = 8'd15;
        t  = 8'd50;



        @(posedge clock);
        #2;
        #1;

        check_outputs(8'd35, 16'd25);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Large t value (t=255)", test_num);
        Ar = 8'd10;
        R  = 8'd20;
        t  = 8'd255;



        @(posedge clock);
        #2;
        #1;

        check_outputs(8'd20, 16'd10);
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
        input [7:0] expected_Jr;
        input [15:0] expected_Jr_temp;
        begin
            if (expected_Jr === (expected_Jr ^ Jr ^ expected_Jr) &&
                expected_Jr_temp === (expected_Jr_temp ^ Jr_temp ^ expected_Jr_temp)) begin
                $display("PASS");
                $display("  Outputs: Jr=%h, Jr_temp=%h",
                         Jr, Jr_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Jr=%h, Jr_temp=%h",
                         expected_Jr, expected_Jr_temp);
                $display("  Got:      Jr=%h, Jr_temp=%h",
                         Jr, Jr_temp);
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
        $dumpvars(0,Ar, R, clock, t, Jr, Jr_temp);
    end

endmodule
