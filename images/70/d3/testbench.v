`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] istr;
    wire [2:0] opLen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .istr(istr),
        .opLen(opLen)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        istr = 16'h0000;

        #1;


        check_outputs(3'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 14 Set", test_num);
        istr = 16'h4000;

        #1;


        check_outputs(3'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 15 Set", test_num);
        istr = 16'h8000;

        #1;


        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 15 and 14 Set", test_num);
        istr = 16'hC000;

        #1;


        check_outputs(3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 15, 14, and 13 Set", test_num);
        istr = 16'hE000;

        #1;


        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Top 4 Bits Set", test_num);
        istr = 16'hF000;

        #1;


        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Low Byte Pattern", test_num);
        istr = 16'h00FF;

        #1;


        check_outputs(3'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits", test_num);
        istr = 16'hAAAA;

        #1;


        check_outputs(3'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits Inverse", test_num);
        istr = 16'h5555;

        #1;


        check_outputs(3'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        istr = 16'hFFFF;

        #1;


        check_outputs(3'd6);
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
        input [2:0] expected_opLen;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_opLen === (expected_opLen ^ opLen ^ expected_opLen)) begin
                $display("PASS");
                $display("  Outputs: opLen=%h",
                         opLen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: opLen=%h",
                         expected_opLen);
                $display("  Got:      opLen=%h",
                         opLen);
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
