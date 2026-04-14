`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CLK;
    reg RST;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RST(RST),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'd12;
            B = 4'd8;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 4'd0;
            B = 4'd10;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 4'd7;
            B = 4'd7;
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'd8;
            B = 4'd8;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 4'd2;
            B = 4'd2;
            @(posedge CLK);
            #1;
            A = 4'd4;
            B = 4'd6;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(5'd10);
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
        input [4:0] expected_SUM;
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
        $dumpvars(0,A, B, CLK, RST, SUM);
    end

endmodule
