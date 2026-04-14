`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg CLK;
    reg Q_reg_1_0;
    reg [2:0] Q_reg_2_0;
    wire D;
    wire DI;
    wire OVRFLW_FLAG_FRMT;
    wire [1:0] Q;
    wire UNDRFLW_FLAG_FRMT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .CLK(CLK),
        .Q_reg_1_0(Q_reg_1_0),
        .Q_reg_2_0(Q_reg_2_0),
        .D(D),
        .DI(DI),
        .OVRFLW_FLAG_FRMT(OVRFLW_FLAG_FRMT),
        .Q(Q),
        .UNDRFLW_FLAG_FRMT(UNDRFLW_FLAG_FRMT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            AR = 1'b1;
            Q_reg_1_0 = 1'b0;
            Q_reg_2_0 = 3'b000;
            #10;
            AR = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            AR = 1'b1;
            Q_reg_1_0 = 1'b0;
            Q_reg_2_0 = 3'b000;
            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 1'b0);
            AR = 1'b0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Q_reg_1_0 = 1'b0;
            Q_reg_2_0 = 3'b000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Q_reg_1_0 = 1'b1;
            Q_reg_2_0 = 3'b000;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 2'b01, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Q_reg_1_0 = 1'b1;
            Q_reg_2_0 = 3'b001;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 2'b10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Q_reg_1_0 = 1'b1;
            Q_reg_2_0 = 3'b010;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 2'b11, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Q_reg_1_0 = 1'b1;
            Q_reg_2_0 = 3'b011;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            Q_reg_1_0 = 1'b0;
            Q_reg_2_0 = 3'b111;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 2'b11, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            Q_reg_1_0 = 1'b0;
            Q_reg_2_0 = 3'b100;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            Q_reg_1_0 = 1'b1;
            Q_reg_2_0 = 3'b111;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 2'b00, 1'b0);
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
        input expected_D;
        input expected_DI;
        input expected_OVRFLW_FLAG_FRMT;
        input [1:0] expected_Q;
        input expected_UNDRFLW_FLAG_FRMT;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_DI === (expected_DI ^ DI ^ expected_DI) &&
                expected_OVRFLW_FLAG_FRMT === (expected_OVRFLW_FLAG_FRMT ^ OVRFLW_FLAG_FRMT ^ expected_OVRFLW_FLAG_FRMT) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_UNDRFLW_FLAG_FRMT === (expected_UNDRFLW_FLAG_FRMT ^ UNDRFLW_FLAG_FRMT ^ expected_UNDRFLW_FLAG_FRMT)) begin
                $display("PASS");
                $display("  Outputs: D=%b, DI=%b, OVRFLW_FLAG_FRMT=%b, Q=%h, UNDRFLW_FLAG_FRMT=%b",
                         D, DI, OVRFLW_FLAG_FRMT, Q, UNDRFLW_FLAG_FRMT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%b, DI=%b, OVRFLW_FLAG_FRMT=%b, Q=%h, UNDRFLW_FLAG_FRMT=%b",
                         expected_D, expected_DI, expected_OVRFLW_FLAG_FRMT, expected_Q, expected_UNDRFLW_FLAG_FRMT);
                $display("  Got:      D=%b, DI=%b, OVRFLW_FLAG_FRMT=%b, Q=%h, UNDRFLW_FLAG_FRMT=%b",
                         D, DI, OVRFLW_FLAG_FRMT, Q, UNDRFLW_FLAG_FRMT);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,AR, CLK, Q_reg_1_0, Q_reg_2_0, D, DI, OVRFLW_FLAG_FRMT, Q, UNDRFLW_FLAG_FRMT);
    end

endmodule
