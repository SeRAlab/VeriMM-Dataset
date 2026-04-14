`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg sel;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: sel=0, select input a");
            a = 3'b101;
            b = 3'b010;
            sel = 1'b0;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: sel=1, select input b");
            a = 3'b101;
            b = 3'b010;
            sel = 1'b1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All zeros boundary");
            a = 3'b000;
            b = 3'b000;
            sel = 1'b0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All ones boundary");
            a = 3'b111;
            b = 3'b111;
            sel = 1'b1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating patterns, sel=0");
            a = 3'b010;
            b = 3'b101;
            sel = 1'b0;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating patterns, sel=1");
            a = 3'b010;
            b = 3'b101;
            sel = 1'b1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Walk through bits on a");
            a = 3'b100;
            b = 3'b001;
            sel = 1'b0;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Walk through bits on b");
            a = 3'b100;
            b = 3'b001;
            sel = 1'b1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Change sel while inputs are static");
            a = 3'b110;
            b = 3'b011;
            sel = 1'b0;
            #2;
            sel = 1'b1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Change inputs while sel is static");
            sel = 1'b0;
            a = 3'b111;
            b = 3'b000;
            #2;
            a = 3'b101;
            #1;

            check_outputs(3'b101);
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
