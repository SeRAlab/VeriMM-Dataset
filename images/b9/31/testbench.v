`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_RW;
    reg EX_regwe;
    reg ID_jmp_need_reg;
    reg ID_jmp_reg;
    reg ID_misprediction;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    reg [4:0] MEM_RW;
    reg MEM_ramtoreg;
    wire branch_flushD;
    wire branch_flushE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_RW(EX_RW),
        .EX_regwe(EX_regwe),
        .ID_jmp_need_reg(ID_jmp_need_reg),
        .ID_jmp_reg(ID_jmp_reg),
        .ID_misprediction(ID_misprediction),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .MEM_RW(MEM_RW),
        .MEM_ramtoreg(MEM_ramtoreg),
        .branch_flushD(branch_flushD),
        .branch_flushE(branch_flushE)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All signals low (No hazards)", test_num);
            ID_rs = 5'd0;
            ID_rt = 5'd0;
            EX_regwe = 1'b0;
            EX_RW = 5'd0;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Branch Misprediction", test_num);
            ID_rs = 5'd1;
            ID_rt = 5'd2;
            EX_regwe = 1'b0;
            EX_RW = 5'd0;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Jump instruction needing register", test_num);
            ID_rs = 5'd4;
            ID_rt = 5'd0;
            EX_regwe = 1'b0;
            EX_RW = 5'd0;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b1;
            ID_jmp_reg = 1'b1;
            ID_misprediction = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data Hazard - EX stage match ID_rs", test_num);
            ID_rs = 5'd10;
            ID_rt = 5'd11;
            EX_regwe = 1'b1;
            EX_RW = 5'd10;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data Hazard - EX stage match ID_rt", test_num);
            ID_rs = 5'd10;
            ID_rt = 5'd11;
            EX_regwe = 1'b1;
            EX_RW = 5'd11;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Data Hazard - MEM stage load-use match ID_rs", test_num);
            ID_rs = 5'd15;
            ID_rt = 5'd16;
            EX_regwe = 1'b0;
            EX_RW = 5'd0;
            MEM_ramtoreg = 1'b1;
            MEM_RW = 5'd15;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Data Hazard - MEM stage load-use match ID_rt", test_num);
            ID_rs = 5'd15;
            ID_rt = 5'd16;
            EX_regwe = 1'b0;
            EX_RW = 5'd0;
            MEM_ramtoreg = 1'b1;
            MEM_RW = 5'd16;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Simultaneous Jump and EX Hazard", test_num);
            ID_rs = 5'd20;
            ID_rt = 5'd21;
            EX_regwe = 1'b1;
            EX_RW = 5'd20;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd0;
            ID_jmp_need_reg = 1'b1;
            ID_jmp_reg = 1'b1;
            ID_misprediction = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Non-matching Register Write Enable", test_num);
            ID_rs = 5'd10;
            ID_rt = 5'd11;
            EX_regwe = 1'b0;
            EX_RW = 5'd10;
            MEM_ramtoreg = 1'b0;
            MEM_RW = 5'd11;
            ID_jmp_need_reg = 1'b0;
            ID_jmp_reg = 1'b0;
            ID_misprediction = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Multiple flush conditions (Mispredict priority)", test_num);
            ID_rs = 5'd5;
            ID_rt = 5'd6;
            EX_regwe = 1'b1;
            EX_RW = 5'd5;
            MEM_ramtoreg = 1'b1;
            MEM_RW = 5'd6;
            ID_jmp_need_reg = 1'b1;
            ID_jmp_reg = 1'b1;
            ID_misprediction = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_branch_flushD;
        input expected_branch_flushE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch_flushD === (expected_branch_flushD ^ branch_flushD ^ expected_branch_flushD) &&
                expected_branch_flushE === (expected_branch_flushE ^ branch_flushE ^ expected_branch_flushE)) begin
                $display("PASS");
                $display("  Outputs: branch_flushD=%b, branch_flushE=%b",
                         branch_flushD, branch_flushE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch_flushD=%b, branch_flushE=%b",
                         expected_branch_flushD, expected_branch_flushE);
                $display("  Got:      branch_flushD=%b, branch_flushE=%b",
                         branch_flushD, branch_flushE);
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
