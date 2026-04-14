`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D0;
    reg [1:0] D1;
    reg RST;
    wire Q0;
    wire [1:0] Q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D0(D0),
        .D1(D1),
        .RST(RST),
        .Q0(Q0),
        .Q1(Q1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            D0 = 0;
            D1 = 2'b00;
            #12;
            RST = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Loading Q0 with 1", test_num);
            reset_dut();
            @(negedge CLK);
            D0 = 1'b1;
            D1 = 2'b00;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Loading Q1 with 2'b11", test_num);
            reset_dut();
            @(negedge CLK);
            D0 = 1'b0;
            D1 = 2'b11;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Loading both Q0 and Q1", test_num);
            reset_dut();
            @(negedge CLK);
            D0 = 1'b1;
            D1 = 2'b10;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            @(negedge CLK);
            D0 = 1'b1;
            D1 = 2'b11;
            @(posedge CLK);
            #2;
            RST = 1;
            #2;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data Stability (No Clock Edge)", test_num);
            reset_dut();
            @(negedge CLK);
            D0 = 1'b1;
            D1 = 2'b01;
            #2;

            #1;


            check_outputs(1'b0, 2'b00);
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
        input expected_Q0;
        input [1:0] expected_Q1;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%h",
                         Q0, Q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%h",
                         expected_Q0, expected_Q1);
                $display("  Got:      Q0=%b, Q1=%h",
                         Q0, Q1);
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
        $dumpvars(0,CLK, D0, D1, RST, Q0, Q1);
    end

endmodule
