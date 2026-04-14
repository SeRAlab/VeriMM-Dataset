`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTag_Allign2;
    reg NatLogFlagout_Allign2;
    reg clock;
    reg [35:0] cout_Allign2;
    reg [1:0] idle_Allign2;
    reg [1:0] modeout_Allign2;
    reg operationout_Allign2;
    reg [31:0] sout_Allign2;
    reg [35:0] zout_Allign2;
    wire [7:0] InsTag_AddState;
    wire NatLogFlagout_AddState;
    wire [1:0] idle_AddState;
    wire [1:0] modeout_AddState;
    wire operationout_AddState;
    wire [31:0] sout_AddState;
    wire [27:0] sum_AddState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTag_Allign2(InsTag_Allign2),
        .NatLogFlagout_Allign2(NatLogFlagout_Allign2),
        .clock(clock),
        .cout_Allign2(cout_Allign2),
        .idle_Allign2(idle_Allign2),
        .modeout_Allign2(modeout_Allign2),
        .operationout_Allign2(operationout_Allign2),
        .sout_Allign2(sout_Allign2),
        .zout_Allign2(zout_Allign2),
        .InsTag_AddState(InsTag_AddState),
        .NatLogFlagout_AddState(NatLogFlagout_AddState),
        .idle_AddState(idle_AddState),
        .modeout_AddState(modeout_AddState),
        .operationout_AddState(operationout_AddState),
        .sout_AddState(sout_AddState),
        .sum_AddState(sum_AddState)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            InsTag_Allign2 = 8'h0;
            NatLogFlagout_Allign2 = 1'b0;
            cout_Allign2 = 36'h0;
            idle_Allign2 = 2'b11;
            modeout_Allign2 = 2'b0;
            operationout_Allign2 = 1'b0;
            sout_Allign2 = 32'h0;
            zout_Allign2 = 36'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            idle_Allign2 = 2'b00;
            cout_Allign2 = 36'h00000000A;
            zout_Allign2 = 36'h000000005;
            sout_Allign2 = 32'hDEADBEEF;
            modeout_Allign2 = 2'b01;
            operationout_Allign2 = 1'b0;
            NatLogFlagout_Allign2 = 1'b0;
            InsTag_Allign2 = 8'h01;

            @(posedge clock);
            #2;


            #1;



            check_outputs(8'h01, 1'b0, 2'b00, 2'b01, 1'b0, 32'hDEADBEEF, 28'h000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            idle_Allign2 = 2'b00;
            cout_Allign2 = 36'h0000000FF;
            zout_Allign2 = 36'h000000001;
            sout_Allign2 = 32'h12345678;
            modeout_Allign2 = 2'b10;
            operationout_Allign2 = 1'b1;
            NatLogFlagout_Allign2 = 1'b1;
            InsTag_Allign2 = 8'hAA;

            @(posedge clock);
            #2;


            #1;



            check_outputs(8'hAA, 1'b1, 2'b00, 2'b10, 1'b1, 32'h12345678, 28'h0000100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            idle_Allign2 = 2'b00;
            cout_Allign2 = 36'h007FFFFFF;
            zout_Allign2 = 36'h000000001;
            sout_Allign2 = 32'h0;
            modeout_Allign2 = 2'b00;
            operationout_Allign2 = 1'b0;
            NatLogFlagout_Allign2 = 1'b0;
            InsTag_Allign2 = 8'h55;

            @(posedge clock);
            #2;


            #1;



            check_outputs(8'h55, 1'b0, 2'b00, 2'b00, 1'b0, 32'h0, 28'h8000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            idle_Allign2 = 2'b10;
            cout_Allign2 = 36'hFFFFFFFFF;
            zout_Allign2 = 36'hFFFFFFFFF;
            sout_Allign2 = 32'h0000FFFF;
            modeout_Allign2 = 2'b11;
            operationout_Allign2 = 1'b1;
            NatLogFlagout_Allign2 = 1'b0;
            InsTag_Allign2 = 8'h00;

            @(posedge clock);
            #2;



            #1;




            check_outputs(8'h00, 1'b0, 2'b10, 2'b11, 1'b1, 32'h0000FFFF, sum_AddState);
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
        input [7:0] expected_InsTag_AddState;
        input expected_NatLogFlagout_AddState;
        input [1:0] expected_idle_AddState;
        input [1:0] expected_modeout_AddState;
        input expected_operationout_AddState;
        input [31:0] expected_sout_AddState;
        input [27:0] expected_sum_AddState;
        begin
            if (expected_InsTag_AddState === (expected_InsTag_AddState ^ InsTag_AddState ^ expected_InsTag_AddState) &&
                expected_NatLogFlagout_AddState === (expected_NatLogFlagout_AddState ^ NatLogFlagout_AddState ^ expected_NatLogFlagout_AddState) &&
                expected_idle_AddState === (expected_idle_AddState ^ idle_AddState ^ expected_idle_AddState) &&
                expected_modeout_AddState === (expected_modeout_AddState ^ modeout_AddState ^ expected_modeout_AddState) &&
                expected_operationout_AddState === (expected_operationout_AddState ^ operationout_AddState ^ expected_operationout_AddState) &&
                expected_sout_AddState === (expected_sout_AddState ^ sout_AddState ^ expected_sout_AddState) &&
                expected_sum_AddState === (expected_sum_AddState ^ sum_AddState ^ expected_sum_AddState)) begin
                $display("PASS");
                $display("  Outputs: InsTag_AddState=%h, NatLogFlagout_AddState=%b, idle_AddState=%h, modeout_AddState=%h, operationout_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         InsTag_AddState, NatLogFlagout_AddState, idle_AddState, modeout_AddState, operationout_AddState, sout_AddState, sum_AddState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTag_AddState=%h, NatLogFlagout_AddState=%b, idle_AddState=%h, modeout_AddState=%h, operationout_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         expected_InsTag_AddState, expected_NatLogFlagout_AddState, expected_idle_AddState, expected_modeout_AddState, expected_operationout_AddState, expected_sout_AddState, expected_sum_AddState);
                $display("  Got:      InsTag_AddState=%h, NatLogFlagout_AddState=%b, idle_AddState=%h, modeout_AddState=%h, operationout_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         InsTag_AddState, NatLogFlagout_AddState, idle_AddState, modeout_AddState, operationout_AddState, sout_AddState, sum_AddState);
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
        $dumpvars(0,InsTag_Allign2, NatLogFlagout_Allign2, clock, cout_Allign2, idle_Allign2, modeout_Allign2, operationout_Allign2, sout_Allign2, zout_Allign2, InsTag_AddState, NatLogFlagout_AddState, idle_AddState, modeout_AddState, operationout_AddState, sout_AddState, sum_AddState);
    end

endmodule
