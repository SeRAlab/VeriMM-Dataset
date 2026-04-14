`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] I;
    wire [2:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All zeros input (5'b00000)", test_num);
        I = 5'b00000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: All ones input (5'b11111)", test_num);
        I = 5'b11111;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single bit set (5'b00100)", test_num);
        I = 5'b00100;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Two bits set (5'b10001)", test_num);
        I = 5'b10001;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Three bits set (5'b10110)", test_num);
        I = 5'b10110;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Four bits set (5'b01111)", test_num);
        I = 5'b01111;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Alternate pattern (5'b10101)", test_num);
        I = 5'b10101;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Border values (5'b11000)", test_num);
        I = 5'b11000;
        #1;

        check_outputs(3'd2);
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
        input [2:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
