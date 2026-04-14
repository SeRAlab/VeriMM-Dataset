`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] j;
    reg [15:0] k;
    wire [15:0] l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .j(j),
        .k(k),
        .l(l)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (0000 & 0000)", test_num);
        j = 16'h0000;
        k = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (FFFF & FFFF)", test_num);
        j = 16'hFFFF;
        k = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inverse Patterns (AAAA & 5555)", test_num);
        j = 16'hAAAA;
        k = 16'h5555;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity (1234 & FFFF)", test_num);
        j = 16'h1234;
        k = 16'hFFFF;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Masking (ABCD & 00FF)", test_num);
        j = 16'hABCD;
        k = 16'h00FF;
        #1;

        check_outputs(16'h00CD);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Masking (ABCD & FF00)", test_num);
        j = 16'hABCD;
        k = 16'hFF00;
        #1;

        check_outputs(16'hAB00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit MSB (8000 & 8000)", test_num);
        j = 16'h8000;
        k = 16'h8000;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit LSB (0001 & 0001)", test_num);
        j = 16'h0001;
        k = 16'h0001;
        #1;

        check_outputs(16'h0001);
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
        input [15:0] expected_l;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l === (expected_l ^ l ^ expected_l)) begin
                $display("PASS");
                $display("  Outputs: l=%h",
                         l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l=%h",
                         expected_l);
                $display("  Got:      l=%h",
                         l);
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
