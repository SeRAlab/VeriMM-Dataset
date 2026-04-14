`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg SUB;
    wire CARRY_OUT;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .SUB(SUB),
        .CARRY_OUT(CARRY_OUT),
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
            SUB = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Basic Addition (15 + 25)", test_num);
            A = 8'd15;
            B = 8'd25;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Addition with Carry Out (200 + 100)", test_num);
            A = 8'd200;
            B = 8'd100;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Basic Subtraction (100 - 40)", test_num);
            A = 8'd100;
            B = 8'd40;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Subtraction with Borrow (40 - 100)", test_num);
            A = 8'd40;
            B = 8'd100;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 8'd196);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Max Addition (255 + 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Subtraction Resulting in Zero (128 - 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Toggle SUB Signal mid-operation", test_num);
            A = 8'd50;
            B = 8'd10;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 8'd40);
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
        input expected_CARRY_OUT;
        input [7:0] expected_SUM;
        begin
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, SUM=%h",
                         expected_CARRY_OUT, expected_SUM);
                $display("  Got:      CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
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
        $dumpvars(0,A, B, CLK, SUB, CARRY_OUT, SUM);
    end

endmodule
