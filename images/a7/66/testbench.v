`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Ri_wbi;
    reg ife_wb;
    reg [5:0] op_wb;
    reg [31:0] write_wb;
    wire [4:0] Ri_wbo;
    wire [31:0] pc_new;
    wire pc_update;
    wire [31:0] reg_new;
    wire reg_update;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ri_wbi(Ri_wbi),
        .ife_wb(ife_wb),
        .op_wb(op_wb),
        .write_wb(write_wb),
        .Ri_wbo(Ri_wbo),
        .pc_new(pc_new),
        .pc_update(pc_update),
        .reg_new(reg_new),
        .reg_update(reg_update)
    );
    task testcase001;

        begin


            ife_wb = 1'b0;
            op_wb = 6'h00;
            Ri_wbi = 5'd15;
            write_wb = 32'hAAAA_BBBB;
            #10;
            #1;

            check_outputs(5'd15, 32'h0, 1'b0, 32'hAAAA_BBBB, 1'b1);
        end
        endtask

    task testcase002;

        begin


            ife_wb = 1'b0;
            op_wb = 6'h08;
            Ri_wbi = 5'd2;
            write_wb = 32'h1234_5678;
            #10;
            #1;

            check_outputs(5'd2, 32'h0, 1'b0, 32'h1234_5678, 1'b1);
        end
        endtask

    task testcase003;

        begin


            ife_wb = 1'b1;
            op_wb = 6'h02;
            Ri_wbi = 5'd0;
            write_wb = 32'h0000_0400;
            #10;
            #1;

            check_outputs(5'd0, 32'h0000_0400, 1'b1, 32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin


            ife_wb = 1'b1;
            op_wb = 6'h04;
            Ri_wbi = 5'd0;
            write_wb = 32'h0000_0800;
            #10;
            #1;

            check_outputs(5'd0, 32'h0000_0800, 1'b1, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin


            ife_wb = 1'b0;
            op_wb = 6'h02;
            Ri_wbi = 5'd0;
            write_wb = 32'h0000_0400;
            #10;
            #1;

            check_outputs(5'd0, 32'h0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin

            ife_wb = 1'b0;
            op_wb = 6'h0F;
            Ri_wbi = 5'd31;
            write_wb = 32'hFFFF_0000;
            #10;
            #1;

            check_outputs(5'd31, 32'h0, 1'b0, 32'hFFFF_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin

            ife_wb = 1'b0;
            op_wb = 6'h0D;
            Ri_wbi = 5'd7;
            write_wb = 32'h0000_FFFF;
            #10;
            #1;

            check_outputs(5'd7, 32'h0, 1'b0, 32'h0000_FFFF, 1'b1);
        end
        endtask

    task testcase008;

        begin

            ife_wb = 1'b1;
            op_wb = 6'h05;
            Ri_wbi = 5'd0;
            write_wb = 32'h0000_0C00;
            #10;
            #1;

            check_outputs(5'd0, 32'h0000_0C00, 1'b1, 32'h0, 1'b0);
        end
        endtask

    task testcase009;

        begin


            ife_wb = 1'b1;
            op_wb = 6'h2B;
            Ri_wbi = 5'd10;
            write_wb = 32'hDEAD_BEEF;
            #10;
            #1;

            check_outputs(5'd0, 32'h0, 1'b0, 32'h0, 1'b0);
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
        input [4:0] expected_Ri_wbo;
        input [31:0] expected_pc_new;
        input expected_pc_update;
        input [31:0] expected_reg_new;
        input expected_reg_update;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Ri_wbo === (expected_Ri_wbo ^ Ri_wbo ^ expected_Ri_wbo) &&
                expected_pc_new === (expected_pc_new ^ pc_new ^ expected_pc_new) &&
                expected_pc_update === (expected_pc_update ^ pc_update ^ expected_pc_update) &&
                expected_reg_new === (expected_reg_new ^ reg_new ^ expected_reg_new) &&
                expected_reg_update === (expected_reg_update ^ reg_update ^ expected_reg_update)) begin
                $display("PASS");
                $display("  Outputs: Ri_wbo=%h, pc_new=%h, pc_update=%b, reg_new=%h, reg_update=%b",
                         Ri_wbo, pc_new, pc_update, reg_new, reg_update);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ri_wbo=%h, pc_new=%h, pc_update=%b, reg_new=%h, reg_update=%b",
                         expected_Ri_wbo, expected_pc_new, expected_pc_update, expected_reg_new, expected_reg_update);
                $display("  Got:      Ri_wbo=%h, pc_new=%h, pc_update=%b, reg_new=%h, reg_update=%b",
                         Ri_wbo, pc_new, pc_update, reg_new, reg_update);
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
