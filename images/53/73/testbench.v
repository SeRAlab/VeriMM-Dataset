`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Index;
    wire [7:0] Res;
    wire [7:0] SignRes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Index(Index),
        .Res(Res),
        .SignRes(SignRes)
    );
    task testcase001;

    begin
        test_num = 1;
        Index = 4'd0;
        #1;

        check_outputs(8'h01, 8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Index = 4'd1;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Index = 4'd2;
        #1;

        check_outputs(8'h01, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Index = 4'd3;
        #1;

        check_outputs(8'h01, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Index = 4'd4;
        #1;

        check_outputs(8'h01, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Index = 4'd5;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Index = 4'd6;
        #1;

        check_outputs(8'h01, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Index = 4'd7;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Index = 4'd8;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Index = 4'd15;
        #1;

        check_outputs(8'h00, 8'h01);
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
        input [7:0] expected_Res;
        input [7:0] expected_SignRes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Res === (expected_Res ^ Res ^ expected_Res) &&
                expected_SignRes === (expected_SignRes ^ SignRes ^ expected_SignRes)) begin
                $display("PASS");
                $display("  Outputs: Res=%h, SignRes=%h",
                         Res, SignRes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Res=%h, SignRes=%h",
                         expected_Res, expected_SignRes);
                $display("  Got:      Res=%h, SignRes=%h",
                         Res, SignRes);
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
