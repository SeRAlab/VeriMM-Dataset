`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_MEM_rd;
    reg EX_MEM_regWrite;
    reg [4:0] MEM_WB_rd;
    reg MEM_WB_regWrite;
    reg [4:0] rs;
    reg rst;
    reg [4:0] rt;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_rd(EX_MEM_rd),
        .EX_MEM_regWrite(EX_MEM_regWrite),
        .MEM_WB_rd(MEM_WB_rd),
        .MEM_WB_regWrite(MEM_WB_regWrite),
        .rs(rs),
        .rst(rst),
        .rt(rt),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset functionality", test_num);
            rst = 1;
            rs = 5'd1;
            rt = 5'd2;
            EX_MEM_rd = 5'd1;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd2;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: No hazards", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd1;
            rt = 5'd2;
            EX_MEM_rd = 5'd3;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd4;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: EX hazard on rs", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd10;
            rt = 5'd11;
            EX_MEM_rd = 5'd10;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd0;
            MEM_WB_regWrite = 1'b0;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: EX hazard on rt", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd5;
            rt = 5'd6;
            EX_MEM_rd = 5'd6;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd0;
            MEM_WB_regWrite = 1'b0;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: MEM hazard on rs", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd15;
            rt = 5'd16;
            EX_MEM_rd = 5'd0;
            EX_MEM_regWrite = 1'b0;
            MEM_WB_rd = 5'd15;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: MEM hazard on rt", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd20;
            rt = 5'd21;
            EX_MEM_rd = 5'd0;
            EX_MEM_regWrite = 1'b0;
            MEM_WB_rd = 5'd21;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Priority check EX vs MEM on rs", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd4;
            rt = 5'd31;
            EX_MEM_rd = 5'd4;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd4;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Register $0 hazard check", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd0;
            rt = 5'd0;
            EX_MEM_rd = 5'd0;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd0;
            MEM_WB_regWrite = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: RegWrite disabled check", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd7;
            rt = 5'd8;
            EX_MEM_rd = 5'd7;
            EX_MEM_regWrite = 1'b0;
            MEM_WB_rd = 5'd8;
            MEM_WB_regWrite = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Mixed stage hazards", test_num);
            rst = 1; #10; rst = 0;
            rs = 5'd2;
            rt = 5'd3;
            EX_MEM_rd = 5'd3;
            EX_MEM_regWrite = 1'b1;
            MEM_WB_rd = 5'd2;
            MEM_WB_regWrite = 1'b1;
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
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%h, forwardB=%h",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
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
