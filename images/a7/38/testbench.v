`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [31:0] out;

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
        test_num = test_num + 1;
        in = 16'h0000;
        $display("Testcase %0d: Input = %h (Zero)", test_num, in);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in = 16'h0001;
        $display("Testcase %0d: Input = %h (Small Positive)", test_num, in);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in = 16'h7FFF;
        $display("Testcase %0d: Input = %h (Max Positive)", test_num, in);
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in = 16'h8000;
        $display("Testcase %0d: Input = %h (Min Negative/Most Negative)", test_num, in);
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in = 16'h8001;
        $display("Testcase %0d: Input = %h (Negative Value)", test_num, in);
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in = 16'hFFFF;
        $display("Testcase %0d: Input = %h (Negative One)", test_num, in);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in = 16'h1234;
        $display("Testcase %0d: Input = %h (Arbitrary Positive)", test_num, in);
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in = 16'hABCD;
        $display("Testcase %0d: Input = %h (Arbitrary Negative)", test_num, in);
        #1;

        check_outputs(32'hFFFFABCD);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        in = 16'h5A5A;
        $display("Testcase %0d: Input = %h (Pattern Positive)", test_num, in);
        #1;

        check_outputs(32'h00005A5A);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        in = 16'hA5A5;
        $display("Testcase %0d: Input = %h (Pattern Negative)", test_num, in);
        #1;

        check_outputs(32'hFFFFA5A5);
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
        input [31:0] expected_out;
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
