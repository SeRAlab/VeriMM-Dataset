`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BAUD;
    wire [18:0] k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BAUD(BAUD),
        .k(k)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        BAUD = 4'd0;
        #1;

        check_outputs(19'd166667);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        BAUD = 4'd5;
        #1;

        check_outputs(19'd5208);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        BAUD = 4'd9;
        #1;

        check_outputs(19'd434);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        BAUD = 4'd11;
        #1;

        check_outputs(19'd109);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        BAUD = 4'd12;
        #1;

        check_outputs(19'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        BAUD = 4'd15;
        #1;

        check_outputs(19'd0);
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
        input [18:0] expected_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: k=%h",
                         k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%h",
                         expected_k);
                $display("  Got:      k=%h",
                         k);
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
