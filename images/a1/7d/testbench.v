`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] InA;
    reg [31:0] InB;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InA(InA),
        .InB(InB),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Simple positive addition", test_num);
        InA = 32'd100;
        InB = 32'd250;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Addition with zero", test_num);
        InA = 32'd0;
        InB = 32'hA5A5A5A5;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Positive and negative addition (result positive)", test_num);
        InA = 32'd1000;
        InB = -32'd400;
        #1;

        check_outputs(32'd600);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Positive and negative addition (result negative)", test_num);
        InA = 32'd500;
        InB = -32'd1500;
        #1;

        check_outputs(-32'd1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Two negative numbers", test_num);
        InA = -32'd50;
        InB = -32'd50;
        #1;

        check_outputs(-32'd100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Maximum positive value boundary (Overflow check)", test_num);
        InA = 32'h7FFFFFFF;
        InB = 32'd1;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Minimum negative value boundary (Underflow check)", test_num);
        InA = 32'h80000000;
        InB = -32'd1;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large negative addition", test_num);
        InA = 32'hC0000000;
        InB = 32'hC0000000;

        #1;


        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Complementary values", test_num);
        InA = 32'h55555555;
        InB = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Cancellation to zero", test_num);
        InA = 32'd12345678;
        InB = -32'd12345678;
        #1;

        check_outputs(32'd0);
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
