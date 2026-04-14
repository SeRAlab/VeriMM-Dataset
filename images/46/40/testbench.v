`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s(s)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero Addition", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple Unit Addition", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Maximum Value and One (Overflow Check)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Alternating Bits", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Carry Propagation", test_num);
            a = 32'h0000FFFF;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Arbitrary Pattern 1", test_num);
            a = 32'h12345678;
            b = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bit 31 Addition", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Hex Pattern (DeadBeef)", test_num);
            a = 32'hDEADBEEF;
            b = 32'h00000111;
            #1;

            check_outputs(32'hDEADC000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Powers of 2", test_num);
            a = 32'h00010000;
            b = 32'h00020000;
            #1;

            check_outputs(32'h00030000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random Large Values", test_num);
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
