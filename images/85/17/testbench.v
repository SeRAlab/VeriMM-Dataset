`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] alu_ct;
    reg [31:0] alu_src1;
    reg [31:0] alu_src2;
    reg rst;
    wire [31:0] alu_res;
    wire alu_zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_ct(alu_ct),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .rst(rst),
        .alu_res(alu_res),
        .alu_zero(alu_zero)
    );
    task testcase001;

    begin
        test_num = 1;
        rst = 0;
        alu_ct = OP_ADD;
        alu_src1 = 32'h12345678;
        alu_src2 = 32'h11111111;
        #5;

        #1;


        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rst = 0; #5; rst = 1;
        alu_ct = OP_ADD;
        alu_src1 = 32'd100;
        alu_src2 = 32'd250;
        #5;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rst = 0; #5; rst = 1;
        alu_ct = OP_ADD;
        alu_src1 = 32'hFFFFFFFF;
        alu_src2 = 32'h00000001;
        #5;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rst = 0; #5; rst = 1;
        alu_ct = OP_SUB;
        alu_src1 = 32'd500;
        alu_src2 = 32'd150;
        #5;
        #1;

        check_outputs(32'd350, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rst = 0; #5; rst = 1;
        alu_ct = OP_SUB;
        alu_src1 = 32'hABCDE;
        alu_src2 = 32'hABCDE;
        #5;
        #1;

        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rst = 0; #5; rst = 1;
        alu_ct = OP_SUB;
        alu_src1 = 32'd10;
        alu_src2 = 32'd20;
        #5;

        #1;


        check_outputs(32'hfffffff6, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rst = 0; #5; rst = 1;
        alu_ct = OP_SLT;
        alu_src1 = 32'd5;
        alu_src2 = 32'd10;
        #5;

        #1;


        check_outputs(32'h1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rst = 0; #5; rst = 1;
        alu_ct = OP_SLT;
        alu_src1 = 32'd100;
        alu_src2 = 32'd50;
        #5;

        #1;


        check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        rst = 0; #5; rst = 1;
        alu_ct = OP_INV;
        alu_src1 = 32'h1234;
        alu_src2 = 32'h5678;
        #5;

        #1;


        check_outputs(32'h0, 1'b1);
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
        input [31:0] expected_alu_res;
        input expected_alu_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_res === (expected_alu_res ^ alu_res ^ expected_alu_res) &&
                expected_alu_zero === (expected_alu_zero ^ alu_zero ^ expected_alu_zero)) begin
                $display("PASS");
                $display("  Outputs: alu_res=%h, alu_zero=%b",
                         alu_res, alu_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_res=%h, alu_zero=%b",
                         expected_alu_res, expected_alu_zero);
                $display("  Got:      alu_res=%h, alu_zero=%b",
                         alu_res, alu_zero);
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
