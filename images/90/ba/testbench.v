`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    wire [3:0] out;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .out(out),
        .parity(parity)
    );
    task testcase001;

    begin
        $display("Testcase 001: Select data0 (4'b1010)");
        test_num = 1;
        data0 = 4'b1010;
        sel = 3'd0;
        #1;

        check_outputs(4'b1010, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Select data1 (4'b0111)");
        test_num = 2;
        data1 = 4'b0111;
        sel = 3'd1;
        #1;

        check_outputs(4'b0111, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Select data2 (4'b0000)");
        test_num = 3;
        data2 = 4'b0000;
        sel = 3'd2;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Select data3 (4'b1111)");
        test_num = 4;
        data3 = 4'b1111;
        sel = 3'd3;
        #1;

        check_outputs(4'b1111, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Select data4 (4'b1000)");
        test_num = 5;
        data4 = 4'b1000;
        sel = 3'd4;
        #1;

        check_outputs(4'b1000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Select data5 (4'b0011)");
        test_num = 6;
        data5 = 4'b0011;
        sel = 3'd5;
        #1;

        check_outputs(4'b0011, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Invalid Select (sel = 6)");
        test_num = 7;
        data0 = 4'hA; data1 = 4'hB; data2 = 4'hC;
        data3 = 4'hD; data4 = 4'hE; data5 = 4'hF;
        sel = 3'd6;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Invalid Select (sel = 7)");
        test_num = 8;
        sel = 3'd7;
        #1;

        check_outputs(4'b0000, 1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Verify isolation - change unselected data");
        test_num = 9;
        sel = 3'd2;
        data2 = 4'b1100;
        data0 = 4'b1111;
        data5 = 4'b1111;
        #1;

        check_outputs(4'b1100, 1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Boundary value - single bit on data5");
        test_num = 10;
        data5 = 4'b0001;
        sel = 3'd5;
        #1;

        check_outputs(4'b0001, 1'b1);
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
        input [3:0] expected_out;
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: out=%h, parity=%b",
                         out, parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, parity=%b",
                         expected_out, expected_parity);
                $display("  Got:      out=%h, parity=%b",
                         out, parity);
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
