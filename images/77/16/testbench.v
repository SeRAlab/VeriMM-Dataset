`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [3:0] N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .N(N)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b0000 (0)", test_num);
        B = 4'b0000;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b0101 (5)", test_num);
        B = 4'b0101;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b1001 (9)", test_num);
        B = 4'b1001;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b1110 (14)", test_num);
        B = 4'b1110;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b1111 (15) - Boundary/Rollover Case", test_num);
        B = 4'b1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input B = 4'b1000 (8)", test_num);
        B = 4'b1000;
        #1;

        check_outputs(4'b1001);
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
        input [3:0] expected_N;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N === (expected_N ^ N ^ expected_N)) begin
                $display("PASS");
                $display("  Outputs: N=%h",
                         N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N=%h",
                         expected_N);
                $display("  Got:      N=%h",
                         N);
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
