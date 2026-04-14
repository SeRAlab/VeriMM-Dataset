`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg [2:0] s;
    wire S2;
    wire S3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .s(s),
        .S2(S2),
        .S3(S3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State D (001), g=0 -> Next: E (S2=1, S3=0)", test_num);
        s = 3'b001; g = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State D (001), g=1 -> Next: F (S2=0, S3=1)", test_num);
        s = 3'b001; g = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State E (010), g=0 -> Next: D (S2=0, S3=0)", test_num);
        s = 3'b010; g = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State E (010), g=1 -> Next: F (S2=0, S3=1)", test_num);
        s = 3'b010; g = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State F (100), g=0 -> Next: D (S2=0, S3=0)", test_num);
        s = 3'b100; g = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State F (100), g=1 -> Next: E (S2=1, S3=0)", test_num);
        s = 3'b100; g = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_S2;
        input expected_S3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S2 === (expected_S2 ^ S2 ^ expected_S2) &&
                expected_S3 === (expected_S3 ^ S3 ^ expected_S3)) begin
                $display("PASS");
                $display("  Outputs: S2=%b, S3=%b",
                         S2, S3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S2=%b, S3=%b",
                         expected_S2, expected_S3);
                $display("  Got:      S2=%b, S3=%b",
                         S2, S3);
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
