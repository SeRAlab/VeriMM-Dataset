`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] RotatorBitNum;
    reg [31:0] RotatorIn;
    reg [1:0] RotatorOp;
    wire [31:0] RotatorOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RotatorBitNum(RotatorBitNum),
        .RotatorIn(RotatorIn),
        .RotatorOp(RotatorOp),
        .RotatorOut(RotatorOut)
    );
    task testcase001;

    begin
        test_num = 1;
        RotatorIn = 32'hDEADBEEF;
        RotatorBitNum = 5'd0;
        RotatorOp = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        RotatorIn = 32'h12345678;
        RotatorBitNum = 5'd4;
        RotatorOp = 2'b00;
        #1;

        check_outputs(32'h23456781);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        RotatorIn = 32'h80000001;
        RotatorBitNum = 5'd1;
        RotatorOp = 2'b00;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        RotatorIn = 32'hA5A5A5A5;
        RotatorBitNum = 5'd0;
        RotatorOp = 2'b10;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        RotatorIn = 32'h12345678;
        RotatorBitNum = 5'd8;
        RotatorOp = 2'b10;
        #1;

        check_outputs(32'h00123456);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        RotatorIn = 32'hA5A5A5A5;
        RotatorBitNum = 5'd31;
        RotatorOp = 2'b10;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        RotatorIn = 32'h7FFFFFFF;
        RotatorBitNum = 5'd4;
        RotatorOp = 2'b11;
        #1;

        check_outputs(32'h07FFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        RotatorIn = 32'h87654321;
        RotatorBitNum = 5'd8;
        RotatorOp = 2'b11;
        #1;

        check_outputs(32'hFF876543);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        RotatorIn = 32'h80000000;
        RotatorBitNum = 5'd31;
        RotatorOp = 2'b11;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        RotatorIn = 32'hF000000F;
        RotatorBitNum = 5'd4;
        RotatorOp = 2'b00;
        #1;

        check_outputs(32'h000000FF);
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
        input [31:0] expected_RotatorOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RotatorOut === (expected_RotatorOut ^ RotatorOut ^ expected_RotatorOut)) begin
                $display("PASS");
                $display("  Outputs: RotatorOut=%h",
                         RotatorOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RotatorOut=%h",
                         expected_RotatorOut);
                $display("  Got:      RotatorOut=%h",
                         RotatorOut);
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
