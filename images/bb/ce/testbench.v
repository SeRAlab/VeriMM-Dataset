`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MEM_RegWrite;
    reg [4:0] EX_MEM_RegisterRd;
    reg [4:0] ID_EX_RegisterRs;
    reg [4:0] ID_Ex_RegisterRt;
    reg MEM_WB_RegWrite;
    reg [4:0] MEM_WB_RegisterRd;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_RegisterRd(EX_MEM_RegisterRd),
        .ID_EX_RegisterRs(ID_EX_RegisterRs),
        .ID_Ex_RegisterRt(ID_Ex_RegisterRt),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_RegisterRd(MEM_WB_RegisterRd),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No hazards", test_num);
            EX_MEM_RegWrite = 0;
            MEM_WB_RegWrite = 0;
            EX_MEM_RegisterRd = 5'd10;
            MEM_WB_RegisterRd = 5'd11;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard for Rs", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 0;
            EX_MEM_RegisterRd = 5'd1;
            MEM_WB_RegisterRd = 5'd11;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard for Rt", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 0;
            EX_MEM_RegisterRd = 5'd2;
            MEM_WB_RegisterRd = 5'd11;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM Hazard for Rs", test_num);
            EX_MEM_RegWrite = 0;
            MEM_WB_RegWrite = 1;
            EX_MEM_RegisterRd = 5'd10;
            MEM_WB_RegisterRd = 5'd1;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MEM Hazard for Rt", test_num);
            EX_MEM_RegWrite = 0;
            MEM_WB_RegWrite = 1;
            EX_MEM_RegisterRd = 5'd10;
            MEM_WB_RegisterRd = 5'd2;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard (Rs) and MEM Hazard (Rt)", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 1;
            EX_MEM_RegisterRd = 5'd1;
            MEM_WB_RegisterRd = 5'd2;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd2;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Test (EX takes priority over MEM)", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 1;
            EX_MEM_RegisterRd = 5'd1;
            MEM_WB_RegisterRd = 5'd1;
            ID_EX_RegisterRs = 5'd1;
            ID_Ex_RegisterRt = 5'd5;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register Zero Check", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 1;
            EX_MEM_RegisterRd = 5'd0;
            MEM_WB_RegisterRd = 5'd0;
            ID_EX_RegisterRs = 5'd0;
            ID_Ex_RegisterRt = 5'd0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RegWrite Control Check", test_num);
            EX_MEM_RegWrite = 0;
            MEM_WB_RegWrite = 0;
            EX_MEM_RegisterRd = 5'd5;
            MEM_WB_RegisterRd = 5'd5;
            ID_EX_RegisterRs = 5'd5;
            ID_Ex_RegisterRt = 5'd5;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EX Hazard for both Rs and Rt", test_num);
            EX_MEM_RegWrite = 1;
            MEM_WB_RegWrite = 0;
            EX_MEM_RegisterRd = 5'd8;
            MEM_WB_RegisterRd = 5'd0;
            ID_EX_RegisterRs = 5'd8;
            ID_Ex_RegisterRt = 5'd8;
            #1;

            check_outputs(2'b10, 2'b10);
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
