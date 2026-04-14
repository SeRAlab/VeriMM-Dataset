`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bg;
    reg [3:0] obj;
    reg obj_prio;
    wire is_obj;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bg(bg),
        .obj(obj),
        .obj_prio(obj_prio),
        .is_obj(is_obj),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Both pixels zero (transparent)");
            bg = 4'h0;
            obj = 4'h0;
            obj_prio = 1'b0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Both pixels zero, obj_prio high");
            bg = 4'h0;
            obj = 4'h0;
            obj_prio = 1'b1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Only background non-zero");
            bg = 4'hA;
            obj = 4'h0;
            obj_prio = 1'b0;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Only background non-zero, obj_prio high");
            bg = 4'hA;
            obj = 4'h0;
            obj_prio = 1'b1;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Only object non-zero");
            bg = 4'h0;
            obj = 4'h5;
            obj_prio = 1'b0;
            #1;

            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Only object non-zero, obj_prio high");
            bg = 4'h0;
            obj = 4'h5;
            obj_prio = 1'b1;
            #1;

            check_outputs(1'b1, 4'h5);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Both non-zero, obj priority high");
            bg = 4'h3;
            obj = 4'hC;
            obj_prio = 1'b1;
            #1;

            check_outputs(1'b1, 4'hC);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Both non-zero, obj priority low (bg wins)");
            bg = 4'h3;
            obj = 4'hC;
            obj_prio = 1'b0;
            #1;

            check_outputs(1'b0, 4'h3);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Max values, obj priority high");
            bg = 4'hF;
            obj = 4'hF;
            obj_prio = 1'b1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Max values, obj priority low");
            bg = 4'hF;
            obj = 4'hF;
            obj_prio = 1'b0;
            #1;

            check_outputs(1'b0, 4'hF);
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
        testcase010();
        
        
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
        input expected_is_obj;
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_obj === (expected_is_obj ^ is_obj ^ expected_is_obj) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: is_obj=%b, out=%h",
                         is_obj, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_obj=%b, out=%h",
                         expected_is_obj, expected_out);
                $display("  Got:      is_obj=%b, out=%h",
                         is_obj, out);
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
