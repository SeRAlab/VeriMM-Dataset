`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: en=0, all inputs high. Expect out=0.");
            en = 0;
            sel = 2'b00;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: en=0, changing sel. Expect out=0.");
            en = 0;
            sel = 2'b11;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: en=1, sel=00, in0=1. Expect out=1.");
            en = 1;
            sel = 2'b00;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: en=1, sel=00, in0=0 (others 1). Expect out=0.");
            en = 1;
            sel = 2'b00;
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: en=1, sel=01, in1=1. Expect out=1.");
            en = 1;
            sel = 2'b01;
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: en=1, sel=01, in1=0. Expect out=0.");
            en = 1;
            sel = 2'b01;
            in0 = 1; in1 = 0; in2 = 1; in3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: en=1, sel=10, in2=1. Expect out=1.");
            en = 1;
            sel = 2'b10;
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: en=1, sel=10, in2=0. Expect out=0.");
            en = 1;
            sel = 2'b10;
            in0 = 1; in1 = 1; in2 = 0; in3 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: en=1, sel=11, in3=1. Expect out=1.");
            en = 1;
            sel = 2'b11;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: en=1, sel=11, in3=0. Expect out=0.");
            en = 1;
            sel = 2'b11;
            in0 = 1; in1 = 1; in2 = 1; in3 = 0;
            #1;

            check_outputs(1'b0);
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
