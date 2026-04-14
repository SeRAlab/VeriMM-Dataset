`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [3:0] aluc;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd150;
        b = 32'd50;
        aluc = 4'b0000;
        $display("Testcase %0d: Addition (150 + 50)", test_num);
        #1;

        check_outputs(32'd200);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'd500;
        b = 32'd100;
        aluc = 4'b1000;
        $display("Testcase %0d: Subtraction (500 - 100)", test_num);
        #1;

        check_outputs(32'd400);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'hFFFF0000;
        b = 32'hAAAA5555;
        aluc = 4'b0100;
        $display("Testcase %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        aluc = 4'b0101;
        $display("Testcase %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        aluc = 4'b0110;
        $display("Testcase %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'd4;
        b = 32'h00000001;
        aluc = 4'b0001;
        $display("Testcase %0d: SLL (1 << 4)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'd4;
        b = 32'h80000000;
        aluc = 4'b0010;
        $display("Testcase %0d: SRL (0x80000000 >> 4)", test_num);
        #1;

        check_outputs(32'h08000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'd4;
        b = 32'h80000000;
        aluc = 4'b0011;
        $display("Testcase %0d: SRA (0x80000000 >>> 4)", test_num);
        #1;

        check_outputs(32'hF8000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'd10;
        b = 32'd20;
        aluc = 4'b1000;
        $display("Testcase %0d: Negative Subtraction (10 - 20)", test_num);
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        aluc = 4'b0000;
        $display("Testcase %0d: Max Addition (Overflow)", test_num);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
