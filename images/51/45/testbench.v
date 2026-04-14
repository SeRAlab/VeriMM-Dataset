`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg captnupdt;
    reg clk;
    reg shiftnld;
    wire capture;
    wire mainclk;
    wire update;
    wire updateclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .captnupdt(captnupdt),
        .clk(clk),
        .shiftnld(shiftnld),
        .capture(capture),
        .mainclk(mainclk),
        .update(update),
        .updateclk(updateclk)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: captnupdt=1, shiftnld=0 (Capture High, Update Low, UpdateClk active)", test_num);

        captnupdt = 0; shiftnld = 0; clk = 0;
        #10;


        captnupdt = 1; shiftnld = 0;


        clk = 0;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);


        clk = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: captnupdt=1, shiftnld=1 (Both High - Capture High, Update Low, UpdateClk active)", test_num);
        captnupdt = 0; shiftnld = 0; clk = 0;
        #10;

        captnupdt = 1; shiftnld = 1;


        clk = 0;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);


        clk = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: captnupdt=0, shiftnld=1 (Shift Mode - Capture Low, Update Low, UpdateClk active)", test_num);
        captnupdt = 0; shiftnld = 0; clk = 0;
        #10;

        captnupdt = 0; shiftnld = 1;


        clk = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);


        clk = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: captnupdt=0, shiftnld=0 (Idle Mode - Capture Low, Update High, MainClk active)", test_num);
        captnupdt = 0; shiftnld = 1; clk = 0;
        #10;

        captnupdt = 0; shiftnld = 0;


        clk = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);


        clk = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_capture;
        input expected_mainclk;
        input expected_update;
        input expected_updateclk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_capture === (expected_capture ^ capture ^ expected_capture) &&
                expected_mainclk === (expected_mainclk ^ mainclk ^ expected_mainclk) &&
                expected_update === (expected_update ^ update ^ expected_update) &&
                expected_updateclk === (expected_updateclk ^ updateclk ^ expected_updateclk)) begin
                $display("PASS");
                $display("  Outputs: capture=%b, mainclk=%b, update=%b, updateclk=%b",
                         capture, mainclk, update, updateclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: capture=%b, mainclk=%b, update=%b, updateclk=%b",
                         expected_capture, expected_mainclk, expected_update, expected_updateclk);
                $display("  Got:      capture=%b, mainclk=%b, update=%b, updateclk=%b",
                         capture, mainclk, update, updateclk);
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
