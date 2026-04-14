`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_RFWen;
    reg [3:0] EX_WAddr;
    reg EX_WDataSc2;
    reg [3:0] RAddr1;
    reg [3:0] RAddr2;
    reg [3:0] opCode;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_RFWen(EX_RFWen),
        .EX_WAddr(EX_WAddr),
        .EX_WDataSc2(EX_WDataSc2),
        .RAddr1(RAddr1),
        .RAddr2(RAddr2),
        .opCode(opCode),
        .stall(stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No matching addresses, no hazard expected.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd1;
            RAddr2 = 4'd2;
            EX_WAddr = 4'd3;
            EX_WDataSc2 = 1'b0;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Match on RAddr1 but EX_RFWen is low.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd5;
            RAddr2 = 4'd2;
            EX_WAddr = 4'd5;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Match on Register 0, should not stall.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd0;
            RAddr2 = 4'd0;
            EX_WAddr = 4'd0;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Load-Use hazard detected on RAddr1.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd8;
            RAddr2 = 4'd2;
            EX_WAddr = 4'd8;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Load-Use hazard detected on RAddr2.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd1;
            RAddr2 = 4'd9;
            EX_WAddr = 4'd9;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ALU-to-ALU hazard (should be handled by forwarding, no stall).", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd4;
            RAddr2 = 4'd2;
            EX_WAddr = 4'd4;
            EX_WDataSc2 = 1'b0;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Match on both source registers with Load instruction.", test_num);
            opCode = 4'b0001;
            RAddr1 = 4'd10;
            RAddr2 = 4'd10;
            EX_WAddr = 4'd10;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Match on RAddr1 but opCode is a non-reading instruction (e.g. 4'hF).", test_num);
            opCode = 4'hF;
            RAddr1 = 4'd12;
            RAddr2 = 4'd13;
            EX_WAddr = 4'd12;
            EX_WDataSc2 = 1'b1;
            EX_RFWen = 1'b1;


            #1;



            check_outputs(1'b0);
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
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%b",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b",
                         expected_stall);
                $display("  Got:      stall=%b",
                         stall);
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
