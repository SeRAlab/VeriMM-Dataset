`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] port0;
    reg [7:0] port1;
    reg [7:0] port2;
    reg [7:0] port3;
    reg [1:0] sel;
    wire [7:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .port0(port0),
        .port1(port1),
        .port2(port2),
        .port3(port3),
        .sel(sel),
        .p(p)
    );
    task testcase001;

    begin
        test_num = 1;
        port0 = 8'hAA; port1 = 8'h00; port2 = 8'h00; port3 = 8'h00;
        sel = 2'b00;
        $display("Test Case 001: sel=00 (Select port0)");
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        port0 = 8'h00; port1 = 8'hBB; port2 = 8'h00; port3 = 8'h00;
        sel = 2'b01;
        $display("Test Case 002: sel=01 (Select port1)");
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        port0 = 8'h00; port1 = 8'h00; port2 = 8'hCC; port3 = 8'h00;
        sel = 2'b10;
        $display("Test Case 003: sel=10 (Select port2)");
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        port0 = 8'h00; port1 = 8'h00; port2 = 8'h00; port3 = 8'hDD;
        sel = 2'b11;
        $display("Test Case 004: sel=11 (Select port3)");
        #1;

        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        port0 = 8'h00; port1 = 8'hFF; port2 = 8'hFF; port3 = 8'hFF;
        sel = 2'b00;
        $display("Test Case 005: Data all zeros check");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        port0 = 8'h00; port1 = 8'h00; port2 = 8'h00; port3 = 8'hFF;
        sel = 2'b11;
        $display("Test Case 006: Data all ones check");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        port0 = 8'h12; port1 = 8'h34; port2 = 8'h56; port3 = 8'h78;
        sel = 2'b10;
        $display("Test Case 007: Mixed values check port2");
        #1;

        check_outputs(8'h56);
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
        input [7:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
