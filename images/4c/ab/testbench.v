`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ex_mem_wb;
    reg [4:0] five_bit_mux_out;
    reg [4:0] mem_Write_reg;
    reg [1:0] mem_wb_wb;
    reg [4:0] rs;
    reg [4:0] rt;
    wire [1:0] forward_a_sel;
    wire [1:0] forward_b_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ex_mem_wb(ex_mem_wb),
        .five_bit_mux_out(five_bit_mux_out),
        .mem_Write_reg(mem_Write_reg),
        .mem_wb_wb(mem_wb_wb),
        .rs(rs),
        .rt(rt),
        .forward_a_sel(forward_a_sel),
        .forward_b_sel(forward_b_sel)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero - No hazards", test_num);
        rs = 5'd0;
        rt = 5'd0;
        five_bit_mux_out = 5'd0;
        ex_mem_wb = 2'b00;
        mem_Write_reg = 5'd0;
        mem_wb_wb = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: EX Hazard on rs", test_num);
        rs = 5'd10;
        rt = 5'd12;
        five_bit_mux_out = 5'd10;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd0;
        mem_wb_wb = 2'b00;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: EX Hazard on rt", test_num);
        rs = 5'd10;
        rt = 5'd12;
        five_bit_mux_out = 5'd12;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd0;
        mem_wb_wb = 2'b00;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: MEM Hazard on rs", test_num);
        rs = 5'd15;
        rt = 5'd20;
        five_bit_mux_out = 5'd0;
        ex_mem_wb = 2'b00;
        mem_Write_reg = 5'd15;
        mem_wb_wb = 2'b10;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: MEM Hazard on rt", test_num);
        rs = 5'd15;
        rt = 5'd20;
        five_bit_mux_out = 5'd0;
        ex_mem_wb = 2'b00;
        mem_Write_reg = 5'd20;
        mem_wb_wb = 2'b10;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Hazard on Register 0 (Should NOT forward)", test_num);
        rs = 5'd0;
        rt = 5'd0;
        five_bit_mux_out = 5'd0;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd0;
        mem_wb_wb = 2'b10;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Priority Check - Both EX and MEM match rs", test_num);
        rs = 5'd7;
        rt = 5'd8;
        five_bit_mux_out = 5'd7;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd7;
        mem_wb_wb = 2'b10;

        #1;


        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Simultaneous EX hazard on rs and MEM hazard on rt", test_num);
        rs = 5'd1;
        rt = 5'd2;
        five_bit_mux_out = 5'd1;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd2;
        mem_wb_wb = 2'b10;
        #1;

        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Register match but RegWrite control is LOW", test_num);
        rs = 5'd25;
        rt = 5'd25;
        five_bit_mux_out = 5'd25;
        ex_mem_wb = 2'b00;
        mem_Write_reg = 5'd25;
        mem_wb_wb = 2'b01;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: No register match but RegWrite is HIGH", test_num);
        rs = 5'd1;
        rt = 5'd2;
        five_bit_mux_out = 5'd3;
        ex_mem_wb = 2'b10;
        mem_Write_reg = 5'd4;
        mem_wb_wb = 2'b10;
        #1;

        check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_forward_a_sel;
        input [1:0] expected_forward_b_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward_a_sel === (expected_forward_a_sel ^ forward_a_sel ^ expected_forward_a_sel) &&
                expected_forward_b_sel === (expected_forward_b_sel ^ forward_b_sel ^ expected_forward_b_sel)) begin
                $display("PASS");
                $display("  Outputs: forward_a_sel=%h, forward_b_sel=%h",
                         forward_a_sel, forward_b_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward_a_sel=%h, forward_b_sel=%h",
                         expected_forward_a_sel, expected_forward_b_sel);
                $display("  Got:      forward_a_sel=%h, forward_b_sel=%h",
                         forward_a_sel, forward_b_sel);
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
