`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char_count;
    wire CharReady;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .char_count(char_count),
        .CharReady(CharReady)
    );
    task testcase001;

    begin
        test_num = 1;
        char_count = 4'b0000;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 1)", test_num, char_count);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        char_count = 4'b0001;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 0)", test_num, char_count);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        char_count = 4'b1000;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 0)", test_num, char_count);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        char_count = 4'b1111;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 0)", test_num, char_count);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        char_count = 4'b0110;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 0)", test_num, char_count);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        char_count = 4'b1010;
        $display("Test %0d: Input char_count = %b (Expect CharReady = 0)", test_num, char_count);
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
        input expected_CharReady;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CharReady === (expected_CharReady ^ CharReady ^ expected_CharReady)) begin
                $display("PASS");
                $display("  Outputs: CharReady=%b",
                         CharReady);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CharReady=%b",
                         expected_CharReady);
                $display("  Got:      CharReady=%b",
                         CharReady);
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
