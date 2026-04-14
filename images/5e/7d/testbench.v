`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg id_ex_mr;
    reg [3:0] id_ex_rt;
    reg [3:0] if_id_rs;
    reg [3:0] if_id_rt;
    reg [3:0] opcode;
    wire if_id_write;
    wire pc_write;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .id_ex_mr(id_ex_mr),
        .id_ex_rt(id_ex_rt),
        .if_id_rs(if_id_rs),
        .if_id_rt(if_id_rt),
        .opcode(opcode),
        .if_id_write(if_id_write),
        .pc_write(pc_write),
        .stall(stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Normal Operation", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd1;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd3;
            id_ex_mr = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load-Use Hazard on RS", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd5;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd5;
            id_ex_mr = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load-Use Hazard on RT", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd1;
            if_id_rt = 4'd8;
            id_ex_rt = 4'd8;
            id_ex_mr = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Match with No Memory Read (No Stall)", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd7;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd7;
            id_ex_mr = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Memory Read No Match (No Stall)", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd1;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd9;
            id_ex_mr = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Halt Instruction Detected", test_num);
            opcode = 4'b0100;
            if_id_rs = 4'd1;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd3;
            id_ex_mr = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Load-Use Hazard on Register 0", test_num);
            opcode = 4'b0000;
            if_id_rs = 4'd0;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd0;
            id_ex_mr = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Simultaneous Hazard and Halt", test_num);
            opcode = 4'b0100;
            if_id_rs = 4'd5;
            if_id_rt = 4'd2;
            id_ex_rt = 4'd5;
            id_ex_mr = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_if_id_write;
        input expected_pc_write;
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_if_id_write === (expected_if_id_write ^ if_id_write ^ expected_if_id_write) &&
                expected_pc_write === (expected_pc_write ^ pc_write ^ expected_pc_write) &&
                expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: if_id_write=%b, pc_write=%b, stall=%b",
                         if_id_write, pc_write, stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: if_id_write=%b, pc_write=%b, stall=%b",
                         expected_if_id_write, expected_pc_write, expected_stall);
                $display("  Got:      if_id_write=%b, pc_write=%b, stall=%b",
                         if_id_write, pc_write, stall);
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
