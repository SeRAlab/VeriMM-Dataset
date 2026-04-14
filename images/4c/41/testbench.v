`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUCtrl_i;
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    wire Zero_o;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl_i(ALUCtrl_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .Zero_o(Zero_o),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: AND Operation", test_num);
        ALUCtrl_i = 3'b000;
        data1_i = 32'hFFFF0000;
        data2_i = 32'hAAAA5555;

        #1;


        check_outputs(1'b0, 32'hAAAA0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: XOR Operation", test_num);
        ALUCtrl_i = 3'b001;
        data1_i = 32'hAAAAAAAA;
        data2_i = 32'h55555555;

        #1;


        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: SLL Operation", test_num);
        ALUCtrl_i = 3'b010;
        data1_i = 32'h00000001;
        data2_i = 32'd8;

        #1;


        check_outputs(1'b0, 32'h00000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: ADD Operation", test_num);
        ALUCtrl_i = 3'b011;
        data1_i = 32'd150;
        data2_i = 32'd350;

        #1;


        check_outputs(1'b0, 32'd500);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: SUB Operation (Positive)", test_num);
        ALUCtrl_i = 3'b100;
        data1_i = 32'd1000;
        data2_i = 32'd400;

        #1;


        check_outputs(1'b0, 32'd600);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: SUB Operation (Zero result)", test_num);
        ALUCtrl_i = 3'b100;
        data1_i = 32'hABCDE123;
        data2_i = 32'hABCDE123;

        #1;


        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: MUL Operation", test_num);
        ALUCtrl_i = 3'b101;
        data1_i = 32'd25;
        data2_i = 32'd4;

        #1;


        check_outputs(1'b0, 32'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: SRA Operation (Negative input)", test_num);
        ALUCtrl_i = 3'b111;
        data1_i = 32'h80000000;
        data2_i = 32'd2;

        #1;


        check_outputs(1'b0, 32'hE0000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: ADDI Operation", test_num);
        ALUCtrl_i = 3'b110;
        data1_i = 32'hFFFFFFFE;
        data2_i = 32'h00000002;

        #1;


        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: SRA Operation (Positive input)", test_num);
        ALUCtrl_i = 3'b111;
        data1_i = 32'h0000000F;
        data2_i = 32'd2;

        #1;


        check_outputs(1'b0, 32'h00000003);
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
        input expected_Zero_o;
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Zero_o === (expected_Zero_o ^ Zero_o ^ expected_Zero_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Zero_o=%b, data_o=%h",
                         expected_Zero_o, expected_data_o);
                $display("  Got:      Zero_o=%b, data_o=%h",
                         Zero_o, data_o);
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
