`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] ctrl;
    reg [31:0] data1;
    reg [31:0] data2;
    wire oCarry;
    wire oZero;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data1(data1),
        .data2(data2),
        .oCarry(oCarry),
        .oZero(oZero),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (10 + 20)", test_num);
        data1 = 32'h00000010;
        data2 = 32'h00000020;
        ctrl  = 3'b000;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'h00000030);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition (Max + 1)", test_num);
        data1 = 32'hFFFFFFFF;
        data2 = 32'h00000001;
        ctrl  = 3'b000;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (50 - 20)", test_num);
        data1 = 32'h00000032;
        data2 = 32'h00000014;
        ctrl  = 3'b001;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0, 32'h0000001E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (Result Zero)", test_num);
        data1 = 32'h000000FF;
        data2 = 32'h000000FF;
        ctrl  = 3'b001;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction (Borrow Required)", test_num);
        data1 = 32'h00000005;
        data2 = 32'h0000000A;
        ctrl  = 3'b001;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'hFFFFFFF6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise AND", test_num);
        data1 = 32'hF0F0AAAA;
        data2 = 32'h0F0F5555;
        ctrl  = 3'b010;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise OR", test_num);
        data1 = 32'hF0F0AAAA;
        data2 = 32'h0F0F5555;
        ctrl  = 3'b011;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR", test_num);
        data1 = 32'hAAAAAAAA;
        data2 = 32'h55555555;
        ctrl  = 3'b100;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise XOR (Identity)", test_num);
        data1 = 32'h12345678;
        data2 = 32'h12345678;
        ctrl  = 3'b100;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 1'b0, 32'h00000000);
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
        input expected_oCarry;
        input expected_oZero;
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oCarry === (expected_oCarry ^ oCarry ^ expected_oCarry) &&
                expected_oZero === (expected_oZero ^ oZero ^ expected_oZero) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: oCarry=%b, oZero=%b, out=%h",
                         oCarry, oZero, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCarry=%b, oZero=%b, out=%h",
                         expected_oCarry, expected_oZero, expected_out);
                $display("  Got:      oCarry=%b, oZero=%b, out=%h",
                         oCarry, oZero, out);
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
