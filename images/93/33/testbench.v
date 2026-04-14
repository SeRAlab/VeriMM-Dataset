`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] I;
    reg [1:0] sel;
    wire [11:0] O0;
    wire [11:0] O1;
    wire [11:0] O2;
    wire [11:0] O3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .sel(sel),
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3)
    );
    task testcase001;

    begin
        test_num = 1;
        I = 12'hAAA;
        sel = 2'b00;
        #1;

        check_outputs(12'hAAA, 12'h000, 12'h000, 12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        I = 12'h555;
        sel = 2'b01;
        #1;

        check_outputs(12'h000, 12'h555, 12'h000, 12'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        I = 12'hFFF;
        sel = 2'b10;
        #1;

        check_outputs(12'h000, 12'h000, 12'hFFF, 12'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        I = 12'h123;
        sel = 2'b11;
        #1;

        check_outputs(12'h000, 12'h000, 12'h000, 12'h123);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        I = 12'h000;
        sel = 2'b00;
        #1;

        check_outputs(12'h000, 12'h000, 12'h000, 12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        I = 12'hABC;
        sel = 2'b01;
        #1;

        check_outputs(12'h000, 12'hABC, 12'h000, 12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        I = 12'h888;
        sel = 2'b10;
        #1;

        check_outputs(12'h000, 12'h000, 12'h888, 12'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        I = 12'h777;
        sel = 2'b11;
        #1;

        check_outputs(12'h000, 12'h000, 12'h000, 12'h777);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        I = 12'hFFF;
        sel = 2'b00;
        #1;

        check_outputs(12'hFFF, 12'h000, 12'h000, 12'h000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        I = 12'h5A5;
        sel = 2'b11;
        #1;

        check_outputs(12'h000, 12'h000, 12'h000, 12'h5A5);
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
        testcase009();
        testcase010();
        
        
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
        input [11:0] expected_O0;
        input [11:0] expected_O1;
        input [11:0] expected_O2;
        input [11:0] expected_O3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_O2 === (expected_O2 ^ O2 ^ expected_O2) &&
                expected_O3 === (expected_O3 ^ O3 ^ expected_O3)) begin
                $display("PASS");
                $display("  Outputs: O0=%h, O1=%h, O2=%h, O3=%h",
                         O0, O1, O2, O3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%h, O1=%h, O2=%h, O3=%h",
                         expected_O0, expected_O1, expected_O2, expected_O3);
                $display("  Got:      O0=%h, O1=%h, O2=%h, O3=%h",
                         O0, O1, O2, O3);
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
