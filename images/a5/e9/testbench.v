`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] als;
    reg [1:0] ui;
    wire [1:0] dl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .als(als),
        .ui(ui),
        .dl(dl)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: ALS < 1000 (ALS=500, UI=2'b01)");
        als = 12'd500;
        ui = 2'b01;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: ALS < 1000 (Boundary: ALS=999, UI=2'b10)");
        als = 12'd999;
        ui = 2'b10;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: 1000 <= ALS <= 2000 (Boundary: ALS=1000, UI=2'b01)");
        als = 12'd1000;
        ui = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: 1000 <= ALS <= 2000 (ALS=1500, UI=2'b11)");
        als = 12'd1500;
        ui = 2'b11;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: 1000 <= ALS <= 2000 (Boundary: ALS=2000, UI=2'b10)");
        als = 12'd2000;
        ui = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: ALS > 2000 (Boundary: ALS=2001, UI=2'b11)");
        als = 12'd2001;
        ui = 2'b11;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: ALS > 2000 (Max: ALS=4095, UI=2'b01)");
        als = 12'd4095;
        ui = 2'b01;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_dl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dl === (expected_dl ^ dl ^ expected_dl)) begin
                $display("PASS");
                $display("  Outputs: dl=%h",
                         dl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dl=%h",
                         expected_dl);
                $display("  Got:      dl=%h",
                         dl);
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
