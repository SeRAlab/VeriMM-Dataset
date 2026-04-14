`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg count;
    reg [1:0] lane;
    wire [1:0] Mod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .lane(lane),
        .Mod(Mod)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: count=0, lane=00");
        count = 1'b0;
        lane = 2'b00;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: count=0, lane=01");
        count = 1'b0;
        lane = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: count=0, lane=10");
        count = 1'b0;
        lane = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: count=0, lane=11");
        count = 1'b0;
        lane = 2'b11;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: count=1, lane=00");
        count = 1'b1;
        lane = 2'b00;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: count=1, lane=01");
        count = 1'b1;
        lane = 2'b01;

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: count=1, lane=10");
        count = 1'b1;
        lane = 2'b10;

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: count=1, lane=11");
        count = 1'b1;
        lane = 2'b11;


        #1;



        check_outputs(2'b01);
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
        input [1:0] expected_Mod;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Mod === (expected_Mod ^ Mod ^ expected_Mod)) begin
                $display("PASS");
                $display("  Outputs: Mod=%h",
                         Mod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mod=%h",
                         expected_Mod);
                $display("  Got:      Mod=%h",
                         Mod);
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
