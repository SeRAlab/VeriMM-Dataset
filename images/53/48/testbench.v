`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MEM_RegWre;
    reg [4:0] EX_MEM_Reg_RD;
    reg [4:0] ID_EX_Reg_RS;
    reg [4:0] ID_EX_Reg_RT;
    reg MEM_WB_RegWre;
    reg [4:0] MEM_WB_Reg_RD;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_RegWre(EX_MEM_RegWre),
        .EX_MEM_Reg_RD(EX_MEM_Reg_RD),
        .ID_EX_Reg_RS(ID_EX_Reg_RS),
        .ID_EX_Reg_RT(ID_EX_Reg_RT),
        .MEM_WB_RegWre(MEM_WB_RegWre),
        .MEM_WB_Reg_RD(MEM_WB_Reg_RD),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: No data hazards (independent instructions)", test_num);
            ID_EX_Reg_RS = 5'd1;
            ID_EX_Reg_RT = 5'd2;
            EX_MEM_Reg_RD = 5'd3;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd4;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: EX/MEM hazard for RS (ForwardA = 10)", test_num);
            ID_EX_Reg_RS = 5'd10;
            ID_EX_Reg_RT = 5'd11;
            EX_MEM_Reg_RD = 5'd10;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd12;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: EX/MEM hazard for RT (ForwardB = 10)", test_num);
            ID_EX_Reg_RS = 5'd5;
            ID_EX_Reg_RT = 5'd6;
            EX_MEM_Reg_RD = 5'd6;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd7;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: MEM/WB hazard for RS (ForwardA = 01)", test_num);
            ID_EX_Reg_RS = 5'd15;
            ID_EX_Reg_RT = 5'd16;
            EX_MEM_Reg_RD = 5'd17;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd15;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: MEM/WB hazard for RT (ForwardB = 01)", test_num);
            ID_EX_Reg_RS = 5'd20;
            ID_EX_Reg_RT = 5'd21;
            EX_MEM_Reg_RD = 5'd22;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd21;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Priority handling - EX/MEM wins over MEM/WB", test_num);
            ID_EX_Reg_RS = 5'd25;
            ID_EX_Reg_RT = 5'd26;
            EX_MEM_Reg_RD = 5'd25;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd25;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Register 0 check (no forwarding allowed for R0)", test_num);
            ID_EX_Reg_RS = 5'd0;
            ID_EX_Reg_RT = 5'd0;
            EX_MEM_Reg_RD = 5'd0;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd0;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: RegWre check (no forwarding if RegWre is 0)", test_num);
            ID_EX_Reg_RS = 5'd30;
            ID_EX_Reg_RT = 5'd30;
            EX_MEM_Reg_RD = 5'd30;
            EX_MEM_RegWre = 1'b0;
            MEM_WB_Reg_RD = 5'd30;
            MEM_WB_RegWre = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Mixed forwarding (A from MEM/WB, B from EX/MEM)", test_num);
            ID_EX_Reg_RS = 5'd10;
            ID_EX_Reg_RT = 5'd11;
            EX_MEM_Reg_RD = 5'd11;
            EX_MEM_RegWre = 1'b1;
            MEM_WB_Reg_RD = 5'd10;
            MEM_WB_RegWre = 1'b1;
            #1;

            check_outputs(2'b01, 2'b10);
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
