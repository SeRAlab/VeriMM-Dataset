`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ex_mem_dst_reg;
    reg ex_mem_reg_write;
    reg [4:0] mem_wb_dst_reg;
    reg mem_wb_reg_write;
    reg [4:0] rs;
    reg [4:0] rt;
    wire [3:0] forward_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_mem_dst_reg(ex_mem_dst_reg),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_dst_reg(mem_wb_dst_reg),
        .mem_wb_reg_write(mem_wb_reg_write),
        .rs(rs),
        .rt(rt),
        .forward_control(forward_control)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No hazards (distinct registers)", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd10;
        mem_wb_dst_reg = 5'd11;
        rs = 5'd1;
        rt = 5'd2;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: EX/MEM hazard on rs", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd5;
        mem_wb_dst_reg = 5'd11;
        rs = 5'd5;
        rt = 5'd2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: EX/MEM hazard on rt", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd6;
        mem_wb_dst_reg = 5'd11;
        rs = 5'd1;
        rt = 5'd6;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: MEM/WB hazard on rs", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd10;
        mem_wb_dst_reg = 5'd7;
        rs = 5'd7;
        rt = 5'd2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MEM/WB hazard on rt", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd10;
        mem_wb_dst_reg = 5'd8;
        rs = 5'd1;
        rt = 5'd8;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Hazard on Register 0 (EX stage) - Should not forward", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd0;
        mem_wb_dst_reg = 5'd11;
        rs = 5'd0;
        rt = 5'd0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Hazard on Register 0 (MEM stage) - Should not forward", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd10;
        mem_wb_dst_reg = 5'd0;
        rs = 5'd0;
        rt = 5'd0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Double Hazard on rs (Priority to EX)", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd9;
        mem_wb_dst_reg = 5'd9;
        rs = 5'd9;
        rt = 5'd2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Double Hazard on rt (Priority to EX)", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd12;
        mem_wb_dst_reg = 5'd12;
        rs = 5'd1;
        rt = 5'd12;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Mixed stage hazards (rs: MEM, rt: EX)", test_num);
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;
        ex_mem_dst_reg = 5'd13;
        mem_wb_dst_reg = 5'd14;
        rs = 5'd14;
        rt = 5'd13;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Write signal disabled", test_num);
        ex_mem_reg_write = 0;
        mem_wb_reg_write = 0;
        ex_mem_dst_reg = 5'd15;
        mem_wb_dst_reg = 5'd16;
        rs = 5'd15;
        rt = 5'd16;
        #1;

        check_outputs(4'b0000);
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
        testcase011();
        
        
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
        input [3:0] expected_forward_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_control === (expected_forward_control ^ forward_control ^ expected_forward_control)) begin
                $display("PASS");
                $display("  Outputs: forward_control=%h",
                         forward_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_control=%h",
                         expected_forward_control);
                $display("  Got:      forward_control=%h",
                         forward_control);
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
