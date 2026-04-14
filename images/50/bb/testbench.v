`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] din;
    wire [3:0] bcd;
    wire [15:0] resttemp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .bcd(bcd),
        .resttemp(resttemp)
    );
    task testcase001;

    begin
        test_num = 1;
        din = 16'h0000;
        #10;
        #1;

        check_outputs(4'h0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din = 16'h0001;
        #10;
        #1;

        check_outputs(4'h0, 16'h000A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din = 16'd100;
        #10;
        #1;

        check_outputs(4'h0, 16'h03E8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din = 16'd6553;
        #10;
        #1;

        check_outputs(4'h0, 16'hFFFA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din = 16'd6554;
        #10;
        #1;

        check_outputs(4'h1, 16'h0004);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din = 16'h8000;
        #10;
        #1;

        check_outputs(4'h5, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din = 16'hFFFF;
        #10;
        #1;

        check_outputs(4'h9, 16'hFFF6);
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
        input [3:0] expected_bcd;
        input [15:0] expected_resttemp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd) &&
                expected_resttemp === (expected_resttemp ^ resttemp ^ expected_resttemp)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h, resttemp=%h",
                         bcd, resttemp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h, resttemp=%h",
                         expected_bcd, expected_resttemp);
                $display("  Got:      bcd=%h, resttemp=%h",
                         bcd, resttemp);
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
