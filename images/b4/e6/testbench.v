`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg UP_DOWN;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .UP_DOWN(UP_DOWN),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RESET = 1;
            UP_DOWN = 0;
            @(negedge CLK);
            RESET = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(negedge CLK);
            $display("Testcase 001: Reset check");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            UP_DOWN = 1;
            repeat (5) @(negedge CLK);
            $display("Testcase 002: Up count to 5");
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            UP_DOWN = 0;
            @(negedge CLK);
            $display("Testcase 003: Down count (0 to 15)");
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            UP_DOWN = 1;
            repeat (17) @(negedge CLK);
            $display("Testcase 004: Up count overflow (17 steps)");
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            UP_DOWN = 0;
            repeat (3) @(negedge CLK);
            $display("Testcase 005: Down count (3 steps)");
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            UP_DOWN = 1;
            repeat (10) @(negedge CLK);
            UP_DOWN = 0;
            repeat (4) @(negedge CLK);
            $display("Testcase 006: Direction switch (Up 10, Down 4)");
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            UP_DOWN = 0;
            repeat (16) @(negedge CLK);
            $display("Testcase 007: Down count full cycle (16 steps)");
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,CLK, RESET, UP_DOWN, OUT);
    end

endmodule
