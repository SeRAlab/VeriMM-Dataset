`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALU_output_memory;
    reg [31:0] HI_data_reg;
    reg [31:0] LO_data_reg;
    reg forward_one_decode;
    reg forward_two_decode;
    reg [31:0] read_data_1_reg;
    reg [31:0] read_data_2_reg;
    reg using_HI_LO;
    wire [31:0] comparator_1;
    wire [31:0] comparator_2;
    wire [31:0] resolved_reg_file_output_one;
    wire [31:0] resolved_reg_file_output_two;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_output_memory(ALU_output_memory),
        .HI_data_reg(HI_data_reg),
        .LO_data_reg(LO_data_reg),
        .forward_one_decode(forward_one_decode),
        .forward_two_decode(forward_two_decode),
        .read_data_1_reg(read_data_1_reg),
        .read_data_2_reg(read_data_2_reg),
        .using_HI_LO(using_HI_LO),
        .comparator_1(comparator_1),
        .comparator_2(comparator_2),
        .resolved_reg_file_output_one(resolved_reg_file_output_one),
        .resolved_reg_file_output_two(resolved_reg_file_output_two)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Register Read", test_num);
            ALU_output_memory  = 32'h11111111;
            HI_data_reg        = 32'h22222222;
            LO_data_reg        = 32'h33333333;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b0;
            forward_two_decode = 1'b0;
            using_HI_LO        = 1'b0;


            #1;



            check_outputs(32'h44444444, 32'h55555555, 32'h44444444, 32'h55555555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Forwarding Path 1 Active", test_num);
            ALU_output_memory  = 32'h11111111;
            HI_data_reg        = 32'h22222222;
            LO_data_reg        = 32'h33333333;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b1;
            forward_two_decode = 1'b0;
            using_HI_LO        = 1'b0;


            #1;



            check_outputs(32'h11111111, 32'h55555555, 32'h11111111, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Forwarding Path 2 Active", test_num);
            ALU_output_memory  = 32'h11111111;
            HI_data_reg        = 32'h22222222;
            LO_data_reg        = 32'h33333333;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b0;
            forward_two_decode = 1'b1;
            using_HI_LO        = 1'b0;


            #1;



            check_outputs(32'h44444444, 32'h11111111, 32'h44444444, 32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Forwarding Path 1 & 2 Active", test_num);
            ALU_output_memory  = 32'hAAAA_BBBB;
            HI_data_reg        = 32'h22222222;
            LO_data_reg        = 32'h33333333;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b1;
            forward_two_decode = 1'b1;
            using_HI_LO        = 1'b0;


            #1;



            check_outputs(32'hAAAA_BBBB, 32'hAAAA_BBBB, 32'hAAAA_BBBB, 32'hAAAA_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: HI/LO Selection Active", test_num);
            ALU_output_memory  = 32'h11111111;
            HI_data_reg        = 32'hDEAD_BEEF;
            LO_data_reg        = 32'hBEEF_CAFE;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b0;
            forward_two_decode = 1'b0;
            using_HI_LO        = 1'b1;


            #1;



            check_outputs(32'h44444444, 32'h55555555, 32'hDEAD_BEEF, 32'hBEEF_CAFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: HI/LO Priority over Forwarded Data", test_num);
            ALU_output_memory  = 32'h8888_8888;
            HI_data_reg        = 32'hCCCC_CCCC;
            LO_data_reg        = 32'hDDDD_DDDD;
            read_data_1_reg    = 32'h44444444;
            read_data_2_reg    = 32'h55555555;
            forward_one_decode = 1'b1;
            forward_two_decode = 1'b1;
            using_HI_LO        = 1'b1;


            #1;



            check_outputs(32'h8888_8888, 32'h8888_8888, 32'hCCCC_CCCC, 32'hDDDD_DDDD);
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
        input [31:0] expected_comparator_1;
        input [31:0] expected_comparator_2;
        input [31:0] expected_resolved_reg_file_output_one;
        input [31:0] expected_resolved_reg_file_output_two;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparator_1 === (expected_comparator_1 ^ comparator_1 ^ expected_comparator_1) &&
                expected_comparator_2 === (expected_comparator_2 ^ comparator_2 ^ expected_comparator_2) &&
                expected_resolved_reg_file_output_one === (expected_resolved_reg_file_output_one ^ resolved_reg_file_output_one ^ expected_resolved_reg_file_output_one) &&
                expected_resolved_reg_file_output_two === (expected_resolved_reg_file_output_two ^ resolved_reg_file_output_two ^ expected_resolved_reg_file_output_two)) begin
                $display("PASS");
                $display("  Outputs: comparator_1=%h, comparator_2=%h, resolved_reg_file_output_one=%h, resolved_reg_file_output_two=%h",
                         comparator_1, comparator_2, resolved_reg_file_output_one, resolved_reg_file_output_two);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparator_1=%h, comparator_2=%h, resolved_reg_file_output_one=%h, resolved_reg_file_output_two=%h",
                         expected_comparator_1, expected_comparator_2, expected_resolved_reg_file_output_one, expected_resolved_reg_file_output_two);
                $display("  Got:      comparator_1=%h, comparator_2=%h, resolved_reg_file_output_one=%h, resolved_reg_file_output_two=%h",
                         comparator_1, comparator_2, resolved_reg_file_output_one, resolved_reg_file_output_two);
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
