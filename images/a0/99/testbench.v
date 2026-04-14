`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] D;
    reg EN;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            D = 32'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: EN=1, D=0xA5A5_A5A5", test_num);
            reset_dut();
            EN = 1;
            D = 32'hA5A5_A5A5;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hA5A5_A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: EN=1, D=0x0000_0000", test_num);
            reset_dut();
            EN = 1;
            D = 32'h0000_0000;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: EN=0, D=0x1234_5678 (Expect Q=X)", test_num);
            reset_dut();
            EN = 0;
            D = 32'h1234_5678;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hxxxx_xxxx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Transition EN 1 -> 0", test_num);
            reset_dut();

            EN = 1;
            D = 32'hDEAD_BEEF;
            @(posedge CLK);
            #1;

            EN = 0;
            D = 32'hCAFE_BABE;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hxxxx_xxxx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: EN=1, max value 0xFFFF_FFFF", test_num);
            reset_dut();
            EN = 1;
            D = 32'hFFFF_FFFF;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: EN=0, D changes while EN is low", test_num);
            reset_dut();
            EN = 0;
            D = 32'h0000_1111;
            @(posedge CLK);
            #1;
            D = 32'h2222_3333;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hxxxx_xxxx);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, D, EN, Q);
    end

endmodule
