`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_rs;
    reg [4:0] EX_rt;
    reg MEM_RegWrite;
    reg [4:0] MEM_rd;
    reg WB_RegWrite;
    reg [4:0] WB_rd;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_rd(MEM_rd),
        .WB_RegWrite(WB_RegWrite),
        .WB_rd(WB_rd),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No Hazards", test_num);
            EX_rs = 5'd1; EX_rt = 5'd2;
            MEM_rd = 5'd3; MEM_RegWrite = 1;
            WB_rd = 5'd4; WB_RegWrite = 1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: EX Hazard on rs", test_num);
            EX_rs = 5'd10; EX_rt = 5'd11;
            MEM_rd = 5'd10; MEM_RegWrite = 1;
            WB_rd = 5'd12; WB_RegWrite = 1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: EX Hazard on rt", test_num);
            EX_rs = 5'd10; EX_rt = 5'd11;
            MEM_rd = 5'd11; MEM_RegWrite = 1;
            WB_rd = 5'd12; WB_RegWrite = 1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MEM Hazard on rs", test_num);
            EX_rs = 5'd15; EX_rt = 5'd16;
            MEM_rd = 5'd20; MEM_RegWrite = 1;
            WB_rd = 5'd15; WB_RegWrite = 1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MEM Hazard on rt", test_num);
            EX_rs = 5'd15; EX_rt = 5'd16;
            MEM_rd = 5'd20; MEM_RegWrite = 1;
            WB_rd = 5'd16; WB_RegWrite = 1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Test (MEM > WB)", test_num);
            EX_rs = 5'd7; EX_rt = 5'd8;
            MEM_rd = 5'd7; MEM_RegWrite = 1;
            WB_rd = 5'd7; WB_RegWrite = 1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register Zero Check", test_num);
            EX_rs = 5'd0; EX_rt = 5'd0;
            MEM_rd = 5'd0; MEM_RegWrite = 1;
            WB_rd = 5'd0; WB_RegWrite = 1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: RegWrite Enable Check", test_num);
            EX_rs = 5'd25; EX_rt = 5'd25;
            MEM_rd = 5'd25; MEM_RegWrite = 0;
            WB_rd = 5'd25; WB_RegWrite = 0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed rs(MEM) and rt(WB)", test_num);
            EX_rs = 5'd1; EX_rt = 5'd2;
            MEM_rd = 5'd1; MEM_RegWrite = 1;
            WB_rd = 5'd2; WB_RegWrite = 1;
            #1;

            check_outputs(2'b10, 2'b01);
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
