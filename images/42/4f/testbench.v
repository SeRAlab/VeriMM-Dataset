`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg RESET_B;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RESET_B(RESET_B),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            RESET_B = 0;
            @(posedge CLK);
            #1;
            RESET_B = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (2 + 3)", test_num);
            reset_dut();
            A = 4'd2;
            B = 4'd3;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Rollover (15 + 1)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs (15 + 15)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successive Operations", test_num);
            reset_dut();
            A = 4'd7; B = 4'd2;
            @(posedge CLK);
            #1;
            A = 4'd4; B = 4'd4;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'd8);
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
        input [3:0] expected_SUM;
        begin
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
        $dumpvars(0,A, B, CLK, RESET_B, SUM);
    end

endmodule
