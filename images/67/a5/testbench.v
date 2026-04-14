`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg check;
    reg [31:0] in0;
    reg [31:0] in1;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check(check),
        .in0(in0),
        .in1(in1),
        .out(out)
    );
    task testcase001;

    begin
        $display("testcase001: check=0, select in0");
        check = 1'b0;
        in0 = 32'h12345678;
        in1 = 32'h87654321;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: check=1, select in1");
        check = 1'b1;
        in0 = 32'h12345678;
        in1 = 32'h87654321;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: check=0, in0=All Fs, in1=All 0s");
        check = 1'b0;
        in0 = 32'hFFFFFFFF;
        in1 = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: check=1, in0=All Fs, in1=All 0s");
        check = 1'b1;
        in0 = 32'hFFFFFFFF;
        in1 = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: check=0, alternating bit patterns");
        check = 1'b0;
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: check=1, alternating bit patterns");
        check = 1'b1;
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase007;

    begin
        $display("testcase007: check=0, select in0 (0)");
        check = 1'b0;
        in0 = 32'h00000000;
        in1 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        $display("testcase008: check=1, select in1 (Specific pattern)");
        check = 1'b1;
        in0 = 32'hDEADBEEF;
        in1 = 32'hCAFEBABE;
        #1;

        check_outputs(32'hCAFEBABE);
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
