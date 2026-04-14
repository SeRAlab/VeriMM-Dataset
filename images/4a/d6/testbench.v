`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] c;
    reg d;
    wire [23:0] newcrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .d(d),
        .newcrc(newcrc)
    );
    task testcase001;

    begin
        test_num = 1;
        d = 1'b0;
        c = 24'h000000;
        $display("Testcase 001: All Zeros");
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        d = 1'b1;
        c = 24'h000000;
        $display("Testcase 002: Data High, Initial CRC 0");
        #1;

        check_outputs(24'h864CFB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        d = 1'b0;
        c = 24'h800000;
        $display("Testcase 003: MSB high, Data 0 (Feedback test)");
        #1;

        check_outputs(24'h864CFB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        d = 1'b1;
        c = 24'h800000;
        $display("Testcase 004: MSB high, Data 1 (Feedback cancel)");
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        d = 1'b0;
        c = 24'h000001;
        $display("Testcase 005: Shift test");
        #1;

        check_outputs(24'h000002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        d = 1'b1;
        c = 24'h555555;
        $display("Testcase 006: Pattern 0x555555, Data 1");

        #1;


        check_outputs(24'h2CE951);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        d = 1'b0;
        c = 24'hFFFFFF;
        $display("Testcase 007: All Ones, Data 0");

        #1;


        check_outputs(24'h79B305);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        d = 1'b1;
        c = 24'hFFFFFF;
        $display("Testcase 008: All Ones, Data 1");

        #1;


        check_outputs(24'hFFFFFE);
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
        input [23:0] expected_newcrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_newcrc === (expected_newcrc ^ newcrc ^ expected_newcrc)) begin
                $display("PASS");
                $display("  Outputs: newcrc=%h",
                         newcrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newcrc=%h",
                         expected_newcrc);
                $display("  Got:      newcrc=%h",
                         newcrc);
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
