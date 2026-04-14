`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] exec_rd_exec_value;
    reg [31:0] exec_rd_m0_value;
    reg exec_rd_scc_value;
    reg [63:0] exec_rd_vcc_value;
    reg [31:0] literal_constant;
    reg [31:0] sgpr_rd_data;
    reg [3:0] source_mux_select;
    reg [9:0] src_constant;
    reg [2047:0] vgpr_source_data;
    wire [2047:0] source_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exec_rd_exec_value(exec_rd_exec_value),
        .exec_rd_m0_value(exec_rd_m0_value),
        .exec_rd_scc_value(exec_rd_scc_value),
        .exec_rd_vcc_value(exec_rd_vcc_value),
        .literal_constant(literal_constant),
        .sgpr_rd_data(sgpr_rd_data),
        .source_mux_select(source_mux_select),
        .src_constant(src_constant),
        .vgpr_source_data(vgpr_source_data),
        .source_data(source_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Selecting literal_constant");

            literal_constant = 32'hDEADBEEF;
            source_mux_select = 4'd0;

            #1;


            check_outputs({{2016{1'b0}}, 32'hDEADBEEF});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Selecting positive sign-extended src_constant");
            src_constant = 10'h07F;
            source_mux_select = 4'd1;

            #1;


            check_outputs({{2038{1'b0}}, 10'h07F});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Selecting negative sign-extended src_constant");
            src_constant = 10'h3FF;
            source_mux_select = 4'd1;

            #1;


            check_outputs({2048{1'b1}});
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Selecting sgpr_rd_data");
            sgpr_rd_data = 32'hCAFEBABE;
            source_mux_select = 4'd2;

            #1;


            check_outputs({{2016{1'b0}}, 32'hCAFEBABE});
        end
        endtask

    task testcase005;

        reg [2047:0] wide_data;
        begin
            test_num = 5;
            $display("Testcase 005: Selecting full-width vgpr_source_data");
            wide_data = {256{8'hAA}};
            vgpr_source_data = wide_data;
            source_mux_select = 4'd3;
            #1;

            check_outputs(wide_data);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Selecting exec_rd_exec_value");
            exec_rd_exec_value = 64'hFEDCBA9876543210;
            source_mux_select = 4'd4;

            #1;


            check_outputs({{1984{1'b0}}, 64'hFEDCBA9876543210});
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Selecting exec_rd_vcc_value");
            exec_rd_vcc_value = 64'h0123456789ABCDEF;
            source_mux_select = 4'd5;
            #1;

            check_outputs({{1984{1'b0}}, 64'h0123456789ABCDEF});
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Selecting exec_rd_m0_value");
            exec_rd_m0_value = 32'h88889999;
            source_mux_select = 4'd6;
            #1;

            check_outputs({{2016{1'b0}}, 32'h88889999});
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Selecting exec_rd_scc_value");
            exec_rd_scc_value = 1'b1;
            source_mux_select = 4'd7;
            #1;

            check_outputs({{2047{1'b0}}, 1'b1});
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase 010: Isolation Check (Changing other inputs)");

            source_mux_select = 4'd0;
            literal_constant = 32'h11111111;
            vgpr_source_data = {2048{1'b1}};
            #1;

            check_outputs({{2016{1'b0}}, 32'h11111111});
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
        input [2047:0] expected_source_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_source_data === (expected_source_data ^ source_data ^ expected_source_data)) begin
                $display("PASS");
                $display("  Outputs: source_data=%h",
                         source_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: source_data=%h",
                         expected_source_data);
                $display("  Got:      source_data=%h",
                         source_data);
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
