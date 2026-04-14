`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ex_mem_rd;
    reg ex_mem_regwrite;
    reg [4:0] mem_wb_rd;
    reg mem_wb_regwrite;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_regwrite(ex_mem_regwrite),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_regwrite(mem_wb_regwrite),
        .rs1(rs1),
        .rs2(rs2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: No data hazards", test_num);
        rs1 = 5'd1;
        rs2 = 5'd2;
        ex_mem_rd = 5'd3;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd4;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: EX/MEM hazard on rs1", test_num);
        rs1 = 5'd5;
        rs2 = 5'd6;
        ex_mem_rd = 5'd5;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd7;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: EX/MEM hazard on rs2", test_num);
        rs1 = 5'd8;
        rs2 = 5'd9;
        ex_mem_rd = 5'd9;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd10;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: MEM/WB hazard on rs1", test_num);
        rs1 = 5'd11;
        rs2 = 5'd12;
        ex_mem_rd = 5'd13;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd11;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: MEM/WB hazard on rs2", test_num);
        rs1 = 5'd14;
        rs2 = 5'd15;
        ex_mem_rd = 5'd16;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd15;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Hazard on Register x0 (Should not forward)", test_num);
        rs1 = 5'd0;
        rs2 = 5'd0;
        ex_mem_rd = 5'd0;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Simultaneous hazards rs1(EX) and rs2(WB)", test_num);
        rs1 = 5'd17;
        rs2 = 5'd18;
        ex_mem_rd = 5'd17;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd18;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Priority check - EX/MEM priority for rs1", test_num);
        rs1 = 5'd19;
        rs2 = 5'd20;
        ex_mem_rd = 5'd19;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd19;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: RegWrite control check", test_num);
        rs1 = 5'd21;
        rs2 = 5'd22;
        ex_mem_rd = 5'd21;
        ex_mem_regwrite = 1'b0;
        mem_wb_rd = 5'd22;
        mem_wb_regwrite = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Priority check - EX/MEM priority for rs2", test_num);
        rs1 = 5'd23;
        rs2 = 5'd24;
        ex_mem_rd = 5'd24;
        ex_mem_regwrite = 1'b1;
        mem_wb_rd = 5'd24;
        mem_wb_regwrite = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
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
