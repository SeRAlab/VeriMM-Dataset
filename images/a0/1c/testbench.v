`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i15_0;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i15_0(i15_0),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero input", test_num);
        i15_0 = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Minimum positive input", test_num);
        i15_0 = 16'h0001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Maximum positive signed input (7FFF)", test_num);
        i15_0 = 16'h7FFF;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Minimum negative signed input (8000)", test_num);
        i15_0 = 16'h8000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input -1 (FFFF)", test_num);
        i15_0 = 16'hFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Random positive input (4A2B)", test_num);
        i15_0 = 16'h4A2B;
        #1;

        check_outputs(32'h00004A2B);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Random negative input (B5E1)", test_num);
        i15_0 = 16'hB5E1;
        #1;

        check_outputs(32'hFFFFB5E1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: MSB boundary check (8001)", test_num);
        i15_0 = 16'h8001;
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: MSB boundary check (7FFE)", test_num);
        i15_0 = 16'h7FFE;
        #1;

        check_outputs(32'h00007FFE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Alternating pattern negative (AAAA)", test_num);
        i15_0 = 16'hAAAA;
        #1;

        check_outputs(32'hFFFFAAAA);
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
