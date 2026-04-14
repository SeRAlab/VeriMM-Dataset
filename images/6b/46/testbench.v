`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i;
    wire o0;
    wire o1;
    wire o2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1),
        .o2(o2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase001: i = 3'b000");
        i = 3'b000;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase002: i = 3'b001");
        i = 3'b001;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase003: i = 3'b010");
        i = 3'b010;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase004: i = 3'b011");
        i = 3'b011;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase005: i = 3'b100");
        i = 3'b100;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase006: i = 3'b101");
        i = 3'b101;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running testcase007: i = 3'b110");
        i = 3'b110;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running testcase008: i = 3'b111");
        i = 3'b111;
        #1;

        check_outputs(1, 1, 1);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b",
                         o0, o1, o2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b",
                         expected_o0, expected_o1, expected_o2);
                $display("  Got:      o0=%b, o1=%b, o2=%b",
                         o0, o1, o2);
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
