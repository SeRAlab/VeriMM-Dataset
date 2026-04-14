`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] rd_addr_mem;
    reg [1:0] rd_addr_wb;
    reg reg_write_mem;
    reg reg_write_wb;
    reg [1:0] rs1_addr_ex;
    reg [1:0] rs2_addr_ex;
    wire [1:0] forward_a;
    wire [1:0] forward_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_addr_mem(rd_addr_mem),
        .rd_addr_wb(rd_addr_wb),
        .reg_write_mem(reg_write_mem),
        .reg_write_wb(reg_write_wb),
        .rs1_addr_ex(rs1_addr_ex),
        .rs2_addr_ex(rs2_addr_ex),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    task testcase001;

    begin
        $display("Testcase 001: No hazards - No forwarding expected");
        test_num = 1;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b00;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: MEM hazard on rs1 - forward_a should be 1");
        test_num = 2;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b01;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b11;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: MEM hazard on rs2 - forward_b should be 1");
        test_num = 3;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b10;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b11;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: WB hazard on rs1 - forward_a should be 2");
        test_num = 4;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b01;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: WB hazard on rs2 - forward_b should be 2");
        test_num = 5;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b10;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Double hazard on rs1 - MEM priority (forward_a = 1)");
        test_num = 6;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b01;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b01;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Hazard exists but reg_write is low - no forwarding");
        test_num = 7;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b10;
        rd_addr_mem = 2'b01;
        reg_write_mem = 1'b0;
        rd_addr_wb = 2'b10;
        reg_write_wb = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Mixed hazards - MEM on rs1, WB on rs2");
        test_num = 8;
        rs1_addr_ex = 2'b11;
        rs2_addr_ex = 2'b01;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b01;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b01, 2'b10);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Mixed hazards - WB on rs1, MEM on rs2");
        test_num = 9;
        rs1_addr_ex = 2'b01;
        rs2_addr_ex = 2'b11;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b01;
        reg_write_wb = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Both sources match same stage (MEM)");
        test_num = 10;
        rs1_addr_ex = 2'b11;
        rs2_addr_ex = 2'b11;
        rd_addr_mem = 2'b11;
        reg_write_mem = 1'b1;
        rd_addr_wb = 2'b00;
        reg_write_wb = 1'b0;
        #1;

        check_outputs(2'b01, 2'b01);
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
        input [1:0] expected_forward_a;
        input [1:0] expected_forward_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_a === (expected_forward_a ^ forward_a ^ expected_forward_a) &&
                expected_forward_b === (expected_forward_b ^ forward_b ^ expected_forward_b)) begin
                $display("PASS");
                $display("  Outputs: forward_a=%h, forward_b=%h",
                         forward_a, forward_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_a=%h, forward_b=%h",
                         expected_forward_a, expected_forward_b);
                $display("  Got:      forward_a=%h, forward_b=%h",
                         forward_a, forward_b);
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
