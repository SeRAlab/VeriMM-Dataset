`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] iFp;
    wire oOF;
    wire [7:0] oSmag;
    wire oUF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iFp(iFp),
        .oOF(oOF),
        .oSmag(oSmag),
        .oUF(oUF)
    );
    task testcase001;

    begin
        test_num = test_num + 1;

        iFp = 13'b0_00000_1010101;
        #1;

        check_outputs(1'b0, 8'h55, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;

        iFp = 13'b0_01101_0110011;
        #1;

        check_outputs(1'b1, 8'h33, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;


        iFp = 13'b0_00001_1111111;
        #1;

        check_outputs(1'b0, 8'h3F, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;


        iFp = 13'b0_00100_1010000;
        #1;

        check_outputs(1'b0, 8'h05, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;


        iFp = 13'b1_00010_1010101;
        #1;

        check_outputs(1'b0, 8'h95, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;


        iFp = 13'b1_01111_1111111;
        #1;

        check_outputs(1'b1, 8'hFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        iFp = 13'h0000;
        #1;

        check_outputs(1'b0, 8'h00, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;

        iFp = 13'b0_00111_1111111;
        #1;

        check_outputs(1'b0, 8'h00, 1'b0);
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
        input expected_oOF;
        input [7:0] expected_oSmag;
        input expected_oUF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oOF === (expected_oOF ^ oOF ^ expected_oOF) &&
                expected_oSmag === (expected_oSmag ^ oSmag ^ expected_oSmag) &&
                expected_oUF === (expected_oUF ^ oUF ^ expected_oUF)) begin
                $display("PASS");
                $display("  Outputs: oOF=%b, oSmag=%h, oUF=%b",
                         oOF, oSmag, oUF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oOF=%b, oSmag=%h, oUF=%b",
                         expected_oOF, expected_oSmag, expected_oUF);
                $display("  Got:      oOF=%b, oSmag=%h, oUF=%b",
                         oOF, oSmag, oUF);
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
