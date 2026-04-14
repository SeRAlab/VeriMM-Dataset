`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] LIB;
    reg [11:0] NI;
    reg [3:0] SLControl;
    wire [11:0] SLResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LIB(LIB),
        .NI(NI),
        .SLControl(SLControl),
        .SLResult(SLResult)
    );
    task testcase001;

    begin
        test_num = 1;
        NI = 12'hAAA;
        SLControl = 4'd0;
        LIB = 3'b000;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        NI = 12'h555;
        SLControl = 4'd1;
        LIB = 3'b000;
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        NI = 12'hFFF;
        SLControl = 4'd4;
        LIB = 3'b000;
        #1;

        check_outputs(12'hFF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        NI = 12'hF0F;
        SLControl = 4'd8;
        LIB = 3'b000;
        #1;

        check_outputs(12'hF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        NI = 12'h001;
        SLControl = 4'd11;
        LIB = 3'b000;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        NI = 12'hFFF;
        SLControl = 4'd12;
        LIB = 3'b000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        NI = 12'hAAA;
        SLControl = 4'd1;
        LIB = 3'b111;
        #1;

        check_outputs(12'h555);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        NI = 12'h000;
        SLControl = 4'd2;
        LIB = 3'b111;
        #1;

        check_outputs(12'h003);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        NI = 12'h000;
        SLControl = 4'd3;
        LIB = 3'b111;
        #1;

        check_outputs(12'h007);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        NI = 12'h000;
        SLControl = 4'd15;
        LIB = 3'b111;
        #1;

        check_outputs(12'hFFF);
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
        input [11:0] expected_SLResult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SLResult === (expected_SLResult ^ SLResult ^ expected_SLResult)) begin
                $display("PASS");
                $display("  Outputs: SLResult=%h",
                         SLResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SLResult=%h",
                         expected_SLResult);
                $display("  Got:      SLResult=%h",
                         SLResult);
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
