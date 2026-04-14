`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [3:0] E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .E(E)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input B = 0000 (0)", test_num);
        B = 4'b0000;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input B = 0010 (2)", test_num);
        B = 4'b0010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input B = 0101 (5)", test_num);
        B = 4'b0101;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input B = 1001 (9)", test_num);
        B = 4'b1001;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Input B = 1100 (12)", test_num);
        B = 4'b1100;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input B = 1101 (13)", test_num);
        B = 4'b1101;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input B = 1110 (14)", test_num);
        B = 4'b1110;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Input B = 1111 (15)", test_num);
        B = 4'b1111;
        #1;

        check_outputs(4'b0010);
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
        input [3:0] expected_E;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_E === (expected_E ^ E ^ expected_E)) begin
                $display("PASS");
                $display("  Outputs: E=%h",
                         E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%h",
                         expected_E);
                $display("  Got:      E=%h",
                         E);
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
