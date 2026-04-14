`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple addition without overflow", test_num);
        in = 16'h1002;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum value without overflow", test_num);
        in = 16'h7008;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Overflow check (15 + 1 = 0)", test_num);
        in = 16'hF001;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Overflow check (10 + 11 = 5)", test_num);
        in = 16'hA00B;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Zero inputs", test_num);
        in = 16'h0000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Verifying middle bits are ignored", test_num);
        in = 16'h2FF3;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: All bits set to 1", test_num);
        in = 16'hFFFF;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Upper nibble zero, lower nibble non-zero", test_num);
        in = 16'h0ABC;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Upper nibble non-zero, lower nibble zero", test_num);
        in = 16'hD120;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Random bit patterns", test_num);
        in = 16'h5555;
        #1;

        check_outputs(4'hA);
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
