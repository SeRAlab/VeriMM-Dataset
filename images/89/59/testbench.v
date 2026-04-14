`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PHI1;
    reg W4010;
    reg W4012;
    reg W4013;
    reg W4014;
    reg W4015;
    wire [15:0] CPU_Addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PHI1(PHI1),
        .W4010(W4010),
        .W4012(W4012),
        .W4013(W4013),
        .W4014(W4014),
        .W4015(W4015),
        .CPU_Addr(CPU_Addr)
    );
    task testcase001;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 1;
        $display("Testcase 001: Idle state - All write signals inactive");
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 2;
        $display("Testcase 002: W4010 active");
        W4010 = 1;
        #1;

        check_outputs(16'h4010);
    end
        endtask

    task testcase003;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 3;
        $display("Testcase 003: W4012 active");
        W4012 = 1;
        #1;

        check_outputs(16'h4012);
    end
        endtask

    task testcase004;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 4;
        $display("Testcase 004: W4013 active");
        W4013 = 1;
        #1;

        check_outputs(16'h4013);
    end
        endtask

    task testcase005;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 5;
        $display("Testcase 005: W4014 active");
        W4014 = 1;
        #1;

        check_outputs(16'h4014);
    end
        endtask

    task testcase006;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 6;
        $display("Testcase 006: W4015 active");
        W4015 = 1;
        #1;

        check_outputs(16'h4015);
    end
        endtask

    task testcase007;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 7;
        $display("Testcase 007: Check address stability when PHI1 is High");
        PHI1 = 1;
        W4010 = 1;

        #1;


        check_outputs(16'h4010);
    end
        endtask

    task testcase008;

    begin

        PHI1 = 0; W4010 = 0; W4012 = 0; W4013 = 0; W4014 = 0; W4015 = 0;
        #10;
        test_num = 8;
        $display("Testcase 008: Returning to zero after activity");
        W4012 = 1;
        #10;
        W4012 = 0;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_CPU_Addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CPU_Addr === (expected_CPU_Addr ^ CPU_Addr ^ expected_CPU_Addr)) begin
                $display("PASS");
                $display("  Outputs: CPU_Addr=%h",
                         CPU_Addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CPU_Addr=%h",
                         expected_CPU_Addr);
                $display("  Got:      CPU_Addr=%h",
                         CPU_Addr);
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

endmodule
