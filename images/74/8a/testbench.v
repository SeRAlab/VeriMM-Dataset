`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [16:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in1(in1),
        .in2(in2),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros");
        in1 = 16'h0000;
        in2 = 16'h0000;
        cin = 1'b0;
        #1;

        check_outputs(17'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Carry-in only");
        in1 = 16'h0000;
        in2 = 16'h0000;
        cin = 1'b1;
        #1;

        check_outputs(17'h00001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Simple sum without overflow");
        in1 = 16'h1234;
        in2 = 16'h4321;
        cin = 1'b0;
        #1;

        check_outputs(17'h05555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Simple sum with carry-in");
        in1 = 16'h1010;
        in2 = 16'h0101;
        cin = 1'b1;
        #1;

        check_outputs(17'h01112);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Boundary - result is exactly 2^16 (res[16] should be 1)");
        in1 = 16'h8000;
        in2 = 16'h8000;
        cin = 1'b0;
        #1;

        check_outputs(17'h10000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Bit pattern AAAA and 5555");
        in1 = 16'hAAAA;
        in2 = 16'h5555;
        cin = 1'b0;
        #1;

        check_outputs(17'h0FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Bit pattern AAAA and 5555 with cin");
        in1 = 16'hAAAA;
        in2 = 16'h5555;
        cin = 1'b1;
        #1;

        check_outputs(17'h10000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Maximum possible inputs without cin");
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        cin = 1'b0;
        #1;

        check_outputs(17'h1FFFE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Maximum possible inputs with cin (All bits set)");
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        cin = 1'b1;
        #1;

        check_outputs(17'h1FFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Random sum check");
        in1 = 16'hA5A5;
        in2 = 16'h5A5A;
        cin = 1'b0;
        #1;

        check_outputs(17'h0FFFF);
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
        input [16:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
