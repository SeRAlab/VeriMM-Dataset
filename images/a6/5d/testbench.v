`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] ax;
    reg [8:0] ay;
    wire [17:0] resulta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ax(ax),
        .ay(ay),
        .resulta(resulta)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by Zero", test_num);
        ax = 9'd0;
        ay = 9'd0;
        #1;

        check_outputs(18'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Multiplication (1 * 1)", test_num);
        ax = 9'd1;
        ay = 9'd1;
        #1;

        check_outputs(18'h00001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Unsigned Inputs (511 * 511)", test_num);
        ax = 9'h1FF;
        ay = 9'h1FF;
        #1;

        check_outputs(18'h3FC01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power of Two (256 * 2)", test_num);
        ax = 9'd256;
        ay = 9'd2;
        #1;

        check_outputs(18'h00200);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range Unsigned (127 * 127)", test_num);
        ax = 9'd127;
        ay = 9'd127;
        #1;

        check_outputs(18'h03F01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bit Pattern", test_num);
        ax = 9'h0AA;
        ay = 9'h055;
        #1;

        check_outputs(18'h03872);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Product near Range Limit", test_num);
        ax = 9'd511;
        ay = 9'd2;
        #1;

        check_outputs(18'h003FE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Square of 16", test_num);
        ax = 9'd16;
        ay = 9'd16;
        #1;

        check_outputs(18'h00100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Input ax * small ay", test_num);
        ax = 9'h1FF;
        ay = 9'd5;
        #1;

        check_outputs(18'h009FB);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Prime-like Arbitrary Values (123 * 321)", test_num);
        ax = 9'd123;
        ay = 9'd321;
        #1;

        check_outputs(18'h09A3B);
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
        input [17:0] expected_resulta;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resulta === (expected_resulta ^ resulta ^ expected_resulta)) begin
                $display("PASS");
                $display("  Outputs: resulta=%h",
                         resulta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resulta=%h",
                         expected_resulta);
                $display("  Got:      resulta=%h",
                         resulta);
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
