`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cu_reg_data_loc;
    reg cu_reg_load;
    reg [15:0] m_alu_result;
    reg [15:0] m_dm_dout;
    reg [2:0] m_reg_waddr;
    wire [2:0] wb_reg_waddr;
    wire [15:0] wb_reg_wdata;
    wire wb_reg_wea;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cu_reg_data_loc(cu_reg_data_loc),
        .cu_reg_load(cu_reg_load),
        .m_alu_result(m_alu_result),
        .m_dm_dout(m_dm_dout),
        .m_reg_waddr(m_reg_waddr),
        .wb_reg_waddr(wb_reg_waddr),
        .wb_reg_wdata(wb_reg_wdata),
        .wb_reg_wea(wb_reg_wea)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select ALU result, Write Enable ON", test_num);
            m_alu_result = 16'hAAAA;
            m_dm_dout    = 16'h5555;
            m_reg_waddr  = 3'd3;
            cu_reg_data_loc = 1'b0;
            cu_reg_load     = 1'b1;
            #1;

            check_outputs(3'd3, 16'hAAAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Memory result, Write Enable ON", test_num);
            m_alu_result = 16'h1234;
            m_dm_dout    = 16'hBEEF;
            m_reg_waddr  = 3'd5;
            cu_reg_data_loc = 1'b1;
            cu_reg_load     = 1'b1;
            #1;

            check_outputs(3'd5, 16'hBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select ALU result, Write Enable OFF", test_num);
            m_alu_result = 16'h00FF;
            m_dm_dout    = 16'hFF00;
            m_reg_waddr  = 3'd0;
            cu_reg_data_loc = 1'b0;
            cu_reg_load     = 1'b0;
            #1;

            check_outputs(3'd0, 16'h00FF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select Memory result, Write Enable OFF", test_num);
            m_alu_result = 16'hCAFE;
            m_dm_dout    = 16'hFACE;
            m_reg_waddr  = 3'd7;
            cu_reg_data_loc = 1'b1;
            cu_reg_load     = 1'b0;
            #1;

            check_outputs(3'd7, 16'hFACE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary values, Write Enable ON", test_num);
            m_alu_result = 16'hFFFF;
            m_dm_dout    = 16'h0000;
            m_reg_waddr  = 3'd1;
            cu_reg_data_loc = 1'b0;
            cu_reg_load     = 1'b1;
            #1;

            check_outputs(3'd1, 16'hFFFF, 1'b1);
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
        input [2:0] expected_wb_reg_waddr;
        input [15:0] expected_wb_reg_wdata;
        input expected_wb_reg_wea;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wb_reg_waddr === (expected_wb_reg_waddr ^ wb_reg_waddr ^ expected_wb_reg_waddr) &&
                expected_wb_reg_wdata === (expected_wb_reg_wdata ^ wb_reg_wdata ^ expected_wb_reg_wdata) &&
                expected_wb_reg_wea === (expected_wb_reg_wea ^ wb_reg_wea ^ expected_wb_reg_wea)) begin
                $display("PASS");
                $display("  Outputs: wb_reg_waddr=%h, wb_reg_wdata=%h, wb_reg_wea=%b",
                         wb_reg_waddr, wb_reg_wdata, wb_reg_wea);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_reg_waddr=%h, wb_reg_wdata=%h, wb_reg_wea=%b",
                         expected_wb_reg_waddr, expected_wb_reg_wdata, expected_wb_reg_wea);
                $display("  Got:      wb_reg_waddr=%h, wb_reg_wdata=%h, wb_reg_wea=%b",
                         wb_reg_waddr, wb_reg_wdata, wb_reg_wea);
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
