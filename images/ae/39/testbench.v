`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BranchControl;
    reg ID_EX_MemRead;
    reg [4:0] ID_EX_RegisterRt;
    reg [4:0] IF_ID_RegisterRs;
    reg [4:0] IF_ID_RegisterRt;
    wire Flush;
    wire Stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BranchControl(BranchControl),
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_RegisterRt(ID_EX_RegisterRt),
        .IF_ID_RegisterRs(IF_ID_RegisterRs),
        .IF_ID_RegisterRt(IF_ID_RegisterRt),
        .Flush(Flush),
        .Stall(Stall)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle State (No Hazard, No Branch)", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 0;
            ID_EX_RegisterRt = 5'd1;
            IF_ID_RegisterRs = 5'd2;
            IF_ID_RegisterRt = 5'd3;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stall on Load-use (Rs match)", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 1;
            ID_EX_RegisterRt = 5'd10;
            IF_ID_RegisterRs = 5'd10;
            IF_ID_RegisterRt = 5'd11;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stall on Load-use (Rt match)", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 1;
            ID_EX_RegisterRt = 5'd15;
            IF_ID_RegisterRs = 5'd14;
            IF_ID_RegisterRt = 5'd15;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Flush on BranchControl", test_num);
            BranchControl = 1;
            ID_EX_MemRead = 0;
            ID_EX_RegisterRt = 5'd1;
            IF_ID_RegisterRs = 5'd2;
            IF_ID_RegisterRt = 5'd3;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Stall and Flush", test_num);
            BranchControl = 1;
            ID_EX_MemRead = 1;
            ID_EX_RegisterRt = 5'd20;
            IF_ID_RegisterRs = 5'd20;
            IF_ID_RegisterRt = 5'd21;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Matching registers but MemRead is LOW", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 0;
            ID_EX_RegisterRt = 5'd25;
            IF_ID_RegisterRs = 5'd25;
            IF_ID_RegisterRt = 5'd25;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MemRead is HIGH but registers mismatch", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 1;
            ID_EX_RegisterRt = 5'd5;
            IF_ID_RegisterRs = 5'd6;
            IF_ID_RegisterRt = 5'd7;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load-use hazard on Register 0", test_num);
            BranchControl = 0;
            ID_EX_MemRead = 1;
            ID_EX_RegisterRt = 5'd0;
            IF_ID_RegisterRs = 5'd0;
            IF_ID_RegisterRt = 5'd4;
            #1;

            check_outputs(0, 1);
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
        input expected_Flush;
        input expected_Stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Flush === (expected_Flush ^ Flush ^ expected_Flush) &&
                expected_Stall === (expected_Stall ^ Stall ^ expected_Stall)) begin
                $display("PASS");
                $display("  Outputs: Flush=%b, Stall=%b",
                         Flush, Stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Flush=%b, Stall=%b",
                         expected_Flush, expected_Stall);
                $display("  Got:      Flush=%b, Stall=%b",
                         Flush, Stall);
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
