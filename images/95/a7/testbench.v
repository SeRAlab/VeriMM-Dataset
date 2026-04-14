`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg oe;
    wire out;
    wire outb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .oe(oe),
        .out(out),
        .outb(outb)
    );
    task testcase001;

        begin
            $display("Testcase 001: Buffer mode - driving 0");
            test_num = test_num + 1;

            oe = 1;
            in = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Buffer mode - driving 1");
            test_num = test_num + 1;

            oe = 1;
            in = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Hold mode - keeping 0");
            test_num = test_num + 1;

            oe = 1;
            in = 0;
            #5;

            oe = 0;
            #5;
            in = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Hold mode - keeping 1");
            test_num = test_num + 1;

            oe = 1;
            in = 1;
            #5;

            oe = 0;
            #5;
            in = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Response to input changes when oe is low");
            test_num = test_num + 1;

            oe = 1;
            in = 0;
            #5;
            oe = 0;
            #5;

            in = 1; #2;
            in = 0; #2;
            in = 1; #2;
            in = 0; #2;
            #5;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Re-enabling output after hold");
            test_num = test_num + 1;

            oe = 1; in = 1; #5;
            oe = 0; in = 0; #5;

            oe = 1;
            in = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_out;
        input expected_outb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_outb === (expected_outb ^ outb ^ expected_outb)) begin
                $display("PASS");
                $display("  Outputs: out=%b, outb=%b",
                         out, outb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, outb=%b",
                         expected_out, expected_outb);
                $display("  Got:      out=%b, outb=%b",
                         out, outb);
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
