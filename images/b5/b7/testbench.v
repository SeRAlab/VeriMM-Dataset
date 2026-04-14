`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] a;
    reg [71:0] b;
    reg sa;
    reg sb;
    wire [71:0] muxed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sa(sa),
        .sb(sb),
        .muxed(muxed)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select A (sa=0, sb=0)", test_num);
        a = 72'hA5A5A5A5A5A5A5A5A5;
        b = 72'h5A5A5A5A5A5A5A5A5A;
        sa = 1'b0;
        sb = 1'b0;
        #1;

        check_outputs(72'hA5A5A5A5A5A5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select B (sa=0, sb=1)", test_num);
        a = 72'h1234567890ABCDEF12;
        b = 72'hFEDCBA09876543210F;
        sa = 1'b0;
        sb = 1'b1;
        #1;

        check_outputs(72'hFEDCBA09876543210F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select NOT A (sa=1, sb=0)", test_num);
        a = 72'hFFFFFFFFFFFFFFFFFF;
        b = 72'h000000000000000000;
        sa = 1'b1;
        sb = 1'b0;
        #1;

        check_outputs(72'h000000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select NOT B (sa=1, sb=1)", test_num);
        a = 72'h000000000000000000;
        b = 72'hAAAAAAAAAAAAAAAAAA;
        sa = 1'b1;
        sb = 1'b1;
        #1;

        check_outputs(~72'hAAAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Edge Case - NOT A with Mixed Bits", test_num);
        a = 72'h333333333333333333;
        b = 72'hCCCCCCCCCCCC000000;
        sa = 1'b1;
        sb = 1'b0;
        #1;

        check_outputs(~72'h333333333333333333);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Edge Case - NOT B with All Zeros", test_num);
        a = 72'hFFFFFFFFFFFFFFFFFF;
        b = 72'h000000000000000000;
        sa = 1'b1;
        sb = 1'b1;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFF);
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
        input [71:0] expected_muxed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_muxed === (expected_muxed ^ muxed ^ expected_muxed)) begin
                $display("PASS");
                $display("  Outputs: muxed=%h",
                         muxed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: muxed=%h",
                         expected_muxed);
                $display("  Got:      muxed=%h",
                         muxed);
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
