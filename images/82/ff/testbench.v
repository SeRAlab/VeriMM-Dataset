`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [6:0] keyb_in;
    reg shift;
    wire [6:0] keyb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .keyb_in(keyb_in),
        .shift(shift),
        .keyb_out(keyb_out)
    );
    task testcase001;

        begin
            test_num = 1;
            keyb_in = 7'h61;
            shift = 0;
            ctrl = 0;
            #1;

            check_outputs(7'h61);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            keyb_in = 7'h61;
            shift = 1;
            ctrl = 0;
            #1;

            check_outputs(7'h41);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            keyb_in = 7'h61;
            shift = 0;
            ctrl = 1;
            #1;

            check_outputs(7'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            keyb_in = 7'h41;
            shift = 1;
            ctrl = 0;
            #1;

            check_outputs(7'h41);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            keyb_in = 7'h35;
            shift = 0;
            ctrl = 0;
            #1;

            check_outputs(7'h35);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            keyb_in = 7'h35;
            shift = 1;
            ctrl = 0;
            #1;

            check_outputs(7'h2E);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            keyb_in = 7'h23;
            shift = 1;
            ctrl = 1;
            #1;

            check_outputs(7'h23);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            keyb_in = 7'h30;
            shift = 1;
            ctrl = 0;
            #1;

            check_outputs(7'h2E);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            keyb_in = 7'h7A;
            shift = 1;
            ctrl = 0;
            #1;

            check_outputs(7'h5A);
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
        input [6:0] expected_keyb_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keyb_out === (expected_keyb_out ^ keyb_out ^ expected_keyb_out)) begin
                $display("PASS");
                $display("  Outputs: keyb_out=%h",
                         keyb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keyb_out=%h",
                         expected_keyb_out);
                $display("  Got:      keyb_out=%h",
                         keyb_out);
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
