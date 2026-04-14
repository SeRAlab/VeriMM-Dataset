`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ina;
    reg [31:0] inb;
    reg sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ina(ina),
        .inb(inb),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Select ina (Basic)");
            ina = 32'h12345678;
            inb = 32'h87654321;
            sel = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select inb (Basic)");
            ina = 32'h12345678;
            inb = 32'h87654321;
            sel = 1'b1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Select ina (All F's)");
            ina = 32'hFFFFFFFF;
            inb = 32'h00000000;
            sel = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Select inb (All 0's)");
            ina = 32'hFFFFFFFF;
            inb = 32'h00000000;
            sel = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Select ina (Alternating bits)");
            ina = 32'hAAAAAAAA;
            inb = 32'h55555555;
            sel = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Select inb (Alternating bits)");
            ina = 32'hAAAAAAAA;
            inb = 32'h55555555;
            sel = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Equal inputs, sel=0");
            ina = 32'hDEADBEEF;
            inb = 32'hDEADBEEF;
            sel = 1'b0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Equal inputs, sel=1");
            ina = 32'hDEADBEEF;
            inb = 32'hDEADBEEF;
            sel = 1'b1;
            #1;

            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_out;
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
