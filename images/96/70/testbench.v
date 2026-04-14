`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg EN;
    reg RST;
    wire Q0;
    wire Q1;
    wire Q2;
    wire Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CK(CK),
        .EN(EN),
        .RST(RST),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            @(posedge CK);
            #1;
            RST = 0;


            @(posedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            EN = 1;
            @(posedge CK);
            #1;
            EN = 0;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            EN = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge CK);
            end
            #1;
            EN = 0;

            #1;


            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            EN = 1;
            @(posedge CK);
            @(posedge CK);
            EN = 0;
            @(posedge CK);
            @(posedge CK);
            EN = 1;
            @(posedge CK);
            #1;
            EN = 0;

            #1;


            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            EN = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge CK);
            end
            #1;
            EN = 0;

            #1;


            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            EN = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge CK);
            end
            #1;
            EN = 0;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            EN = 1;
            @(posedge CK);
            @(posedge CK);
            @(posedge CK);
            RST = 1;
            @(posedge CK);
            #1;
            RST = 0;
            EN = 0;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            reset_dut();
            EN = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge CK);
            end
            #1;
            EN = 0;

            #1;


            check_outputs(0, 0, 0, 1);
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
        input expected_Q0;
        input expected_Q1;
        input expected_Q2;
        input expected_Q3;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%b, Q1=%b, Q2=%b, Q3=%b",
                         Q0, Q1, Q2, Q3);
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
        $dumpvars(0,CK, EN, RST, Q0, Q1, Q2, Q3);
    end

endmodule
