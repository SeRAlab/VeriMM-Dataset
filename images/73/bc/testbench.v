`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in_0;
    reg in_1;
    reg in_2;
    reg in_3;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_0(in_0),
        .in_1(in_1),
        .in_2(in_2),
        .in_3(in_3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Select in_0 (sel=00), expect 0");
            in_0 = 1'b0; in_1 = 1'b1; in_2 = 1'b1; in_3 = 1'b1;
            sel = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Select in_0 (sel=00), expect 1");
            in_0 = 1'b1; in_1 = 1'b0; in_2 = 1'b0; in_3 = 1'b0;
            sel = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Select in_1 (sel=01), expect 0");
            in_0 = 1'b1; in_1 = 1'b0; in_2 = 1'b1; in_3 = 1'b1;
            sel = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Select in_1 (sel=01), expect 1");
            in_0 = 1'b0; in_1 = 1'b1; in_2 = 1'b0; in_3 = 1'b0;
            sel = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Select in_2 (sel=10), expect 0");
            in_0 = 1'b1; in_1 = 1'b1; in_2 = 1'b0; in_3 = 1'b1;
            sel = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Select in_2 (sel=10), expect 1");
            in_0 = 1'b0; in_1 = 1'b0; in_2 = 1'b1; in_3 = 1'b0;
            sel = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Select in_3 (sel=11), expect 0");
            in_0 = 1'b1; in_1 = 1'b1; in_2 = 1'b1; in_3 = 1'b0;
            sel = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Select in_3 (sel=11), expect 1");
            in_0 = 1'b0; in_1 = 1'b0; in_2 = 1'b0; in_3 = 1'b1;
            sel = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Verification of Input Isolation (sel=10, in_2=1, toggle others)");
            in_0 = 1'b0; in_1 = 1'b0; in_2 = 1'b1; in_3 = 1'b0;
            sel = 2'b10;
            #5;
            in_0 = 1'b1; in_1 = 1'b1; in_3 = 1'b1;
            #1;

            check_outputs(1'b1);
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
        testcase009();
        
        
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
