`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Initial state (en=0, in=0)");
            test_num = 1;
            en = 0; in = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Set enable high while input is low");
            test_num = 2;
            en = 0; in = 0;
            #10;
            en = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable high, then pull input high");
            test_num = 3;
            en = 0; in = 0;
            #10;
            en = 1;
            #10;
            in = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold state - Change en to 0 while in is high");
            test_num = 4;
            en = 0; in = 0;
            #10;
            en = 1;
            #10;
            in = 1;
            #10;
            en = 0;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Hold state - Enable high while in is already high");
            test_num = 5;
            en = 0; in = 0;
            #10;
            in = 1;
            #10;
            en = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Output follows input low");
            test_num = 6;
            en = 0; in = 0;
            #10;
            en = 1;
            #10;
            in = 1;
            #10;
            in = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Disable sequence");
            test_num = 7;
            en = 0; in = 0;
            #10;
            en = 1; in = 0;
            #10;
            in = 1;
            #10;
            in = 0;
            #10;
            en = 0;
            #10;
            in = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Glitch prevention check (toggle en while in is high)");
            test_num = 8;
            en = 0; in = 0;
            #10;
            en = 1; in = 0;
            #10;
            in = 1;
            #10;
            en = 0; #5; en = 1; #5; en = 0;
            #10;
            #1;

            check_outputs(1);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
