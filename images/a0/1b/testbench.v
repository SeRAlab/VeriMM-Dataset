`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg idx_en;
    reg [15:0] imm_value0;
    reg off_en;
    reg [127:0] scalar_source_a;
    reg [5:0] tid;
    reg [31:0] vector_source_b;
    wire [31:0] out_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .idx_en(idx_en),
        .imm_value0(imm_value0),
        .off_en(off_en),
        .scalar_source_a(scalar_source_a),
        .tid(tid),
        .vector_source_b(vector_source_b),
        .out_addr(out_addr)
    );
    task testcase001;

    begin
        test_num = 1;
        off_en = 1'b0;
        idx_en = 1'b0;
        imm_value0 = 16'hA000;
        vector_source_b = 32'h12345678;
        scalar_source_a = 128'hFFFF;
        tid = 6'd32;


        #1;



        check_outputs(32'h0000A000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        off_en = 1'b1;
        idx_en = 1'b0;
        imm_value0 = 16'hA000;
        vector_source_b = 32'h5555AAAA;
        scalar_source_a = 128'h100;
        tid = 6'd5;


        #1;



        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        off_en = 1'b0;
        idx_en = 1'b1;
        imm_value0 = 16'h0100;
        vector_source_b = 32'h0;
        scalar_source_a = 128'h00000004;
        tid = 6'd10;


        #1;



        check_outputs(32'h00000128);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        off_en = 1'b1;
        idx_en = 1'b1;
        imm_value0 = 16'h0;
        vector_source_b = 32'h00001000;
        scalar_source_a = 128'h00000010;
        tid = 6'd4;


        #1;



        check_outputs(32'h00001040);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        off_en = 1'b1;
        idx_en = 1'b1;
        imm_value0 = 16'h0;
        vector_source_b = 32'h00002000;
        scalar_source_a = 128'h00000001;
        tid = 6'd63;


        #1;



        check_outputs(32'h0000203F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        off_en = 1'b1;
        idx_en = 1'b1;
        imm_value0 = 16'h0;
        vector_source_b = 32'hFFFFFFFF;
        scalar_source_a = 128'h00000001;
        tid = 6'd1;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        off_en = 1'b1;
        idx_en = 1'b1;
        imm_value0 = 16'h0;
        vector_source_b = 32'h00000000;

        scalar_source_a = {64'hDEADBEEF_DEADBEEF, 32'h0, 32'h00000008};
        tid = 6'd2;


        #1;



        check_outputs(32'h00000010);
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
        input [31:0] expected_out_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_addr === (expected_out_addr ^ out_addr ^ expected_out_addr)) begin
                $display("PASS");
                $display("  Outputs: out_addr=%h",
                         out_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_addr=%h",
                         expected_out_addr);
                $display("  Got:      out_addr=%h",
                         out_addr);
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
