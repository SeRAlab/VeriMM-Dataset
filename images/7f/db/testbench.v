`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [4:0] v0;
    reg [4:0] v1;
    reg [4:0] v2;
    reg [4:0] v3;
    wire [20:0] chi_sqr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .v0(v0),
        .v1(v1),
        .v2(v2),
        .v3(v3),
        .chi_sqr(chi_sqr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Enable signal low (Output should be 0)");
        en = 1'b0;
        v0 = 5'd10; v1 = 5'd15; v2 = 5'd20; v3 = 5'd25;
        #1;

        check_outputs(21'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: All inputs zero, Enable high");
        en = 1'b1;
        v0 = 5'd0; v1 = 5'd0; v2 = 5'd0; v3 = 5'd0;
        #1;

        check_outputs(21'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Uniform small inputs (1, 1, 1, 1)");
        en = 1'b1;
        v0 = 5'd1; v1 = 5'd1; v2 = 5'd1; v3 = 5'd1;

        #1;


        check_outputs(21'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Mixed values (5, 10, 15, 20)");
        en = 1'b1;
        v0 = 5'd5; v1 = 5'd10; v2 = 5'd15; v3 = 5'd20;

        #1;


        check_outputs(21'd750);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Single maximum value (31, 0, 0, 0)");
        en = 1'b1;
        v0 = 5'd31; v1 = 5'd0; v2 = 5'd0; v3 = 5'd0;

        #1;


        check_outputs(21'd961);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: All inputs maximum (31, 31, 31, 31)");
        en = 1'b1;
        v0 = 5'd31; v1 = 5'd31; v2 = 5'd31; v3 = 5'd31;

        #1;


        check_outputs(21'd3844);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Sequential values (1, 2, 3, 4)");
        en = 1'b1;
        v0 = 5'd1; v1 = 5'd2; v2 = 5'd3; v3 = 5'd4;

        #1;


        check_outputs(21'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Prime values (7, 11, 13, 17)");
        en = 1'b1;
        v0 = 5'd7; v1 = 5'd11; v2 = 5'd13; v3 = 5'd17;

        #1;


        check_outputs(21'd628);
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
        input [20:0] expected_chi_sqr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_chi_sqr === (expected_chi_sqr ^ chi_sqr ^ expected_chi_sqr)) begin
                $display("PASS");
                $display("  Outputs: chi_sqr=%h",
                         chi_sqr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chi_sqr=%h",
                         expected_chi_sqr);
                $display("  Got:      chi_sqr=%h",
                         chi_sqr);
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
