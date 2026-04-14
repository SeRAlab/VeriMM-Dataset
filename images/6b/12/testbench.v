`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EXRegRs;
    reg [4:0] EXRegRt;
    reg [4:0] MEMRegRd;
    reg MEM_RegWrite;
    reg [4:0] WBRegRd;
    reg WB_RegWrite;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXRegRs(EXRegRs),
        .EXRegRt(EXRegRt),
        .MEMRegRd(MEMRegRd),
        .MEM_RegWrite(MEM_RegWrite),
        .WBRegRd(WBRegRd),
        .WB_RegWrite(WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No hazards, different registers", test_num);
            EXRegRs = 5'd1; EXRegRt = 5'd2;
            MEMRegRd = 5'd3; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd4; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Hazard on Rs", test_num);
            EXRegRs = 5'd5; EXRegRt = 5'd6;
            MEMRegRd = 5'd5; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd7; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Hazard on Rt", test_num);
            EXRegRs = 5'd8; EXRegRt = 5'd9;
            MEMRegRd = 5'd9; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd10; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: WB Hazard on Rs", test_num);
            EXRegRs = 5'd11; EXRegRt = 5'd12;
            MEMRegRd = 5'd13; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd11; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: WB Hazard on Rt", test_num);
            EXRegRs = 5'd14; EXRegRt = 5'd15;
            MEMRegRd = 5'd16; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd15; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hazard on Register 0 (No Forwarding)", test_num);
            EXRegRs = 5'd0; EXRegRt = 5'd0;
            MEMRegRd = 5'd0; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd0; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegWrite is False", test_num);
            EXRegRs = 5'd20; EXRegRt = 5'd21;
            MEMRegRd = 5'd20; MEM_RegWrite = 1'b0;
            WBRegRd = 5'd21; WB_RegWrite = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Priority Over WB", test_num);
            EXRegRs = 5'd25; EXRegRt = 5'd25;
            MEMRegRd = 5'd25; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd25; WB_RegWrite = 1'b1;

            #1;


            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MEM Hazard on Rs, WB Hazard on Rt", test_num);
            EXRegRs = 5'd26; EXRegRt = 5'd27;
            MEMRegRd = 5'd26; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd27; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: WB Forwarding with unrelated MEM Write", test_num);
            EXRegRs = 5'd28; EXRegRt = 5'd29;
            MEMRegRd = 5'd10; MEM_RegWrite = 1'b1;
            WBRegRd = 5'd28; WB_RegWrite = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_ForwardA;
        input [1:0] expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%h, ForwardB=%h",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
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
