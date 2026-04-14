`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] alu_opcode;
    reg [31:0] immediate_1;
    reg [31:0] immediate_2;
    reg [1:0] input_register_selector_1;
    reg [1:0] input_register_selector_2;
    reg output_enable;
    reg [1:0] output_register_selector;
    reg output_source_selector;
    wire [31:0] input_data_1;
    wire [31:0] input_data_2;
    wire [31:0] output_data;
    wire [1:0] output_register;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_opcode(alu_opcode),
        .immediate_1(immediate_1),
        .immediate_2(immediate_2),
        .input_register_selector_1(input_register_selector_1),
        .input_register_selector_2(input_register_selector_2),
        .output_enable(output_enable),
        .output_register_selector(output_register_selector),
        .output_source_selector(output_source_selector),
        .input_data_1(input_data_1),
        .input_data_2(input_data_2),
        .output_data(output_data),
        .output_register(output_register)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);

            alu_opcode = 2'b00;
            immediate_1 = 32'd10;
            immediate_2 = 32'd20;
            input_register_selector_1 = 2'b00;
            input_register_selector_2 = 2'b01;
            output_enable = 1'b1;
            output_register_selector = 2'b01;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'd10, 32'd20, 32'd30, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Subtraction", test_num);

            alu_opcode = 2'b01;
            immediate_1 = 32'd50;
            immediate_2 = 32'd20;
            input_register_selector_1 = 2'b10;
            input_register_selector_2 = 2'b11;
            output_enable = 1'b1;
            output_register_selector = 2'b11;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'd50, 32'd20, 32'd30, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);

            alu_opcode = 2'b10;
            immediate_1 = 32'hF0F0F0F0;
            immediate_2 = 32'hAAAA5555;
            input_register_selector_1 = 2'b00;
            input_register_selector_2 = 2'b00;
            output_enable = 1'b1;
            output_register_selector = 2'b00;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'hF0F0F0F0, 32'hAAAA5555, 32'hA0A05050, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);

            alu_opcode = 2'b11;
            immediate_1 = 32'h12340000;
            immediate_2 = 32'h00005678;
            input_register_selector_1 = 2'b01;
            input_register_selector_2 = 2'b10;
            output_enable = 1'b1;
            output_register_selector = 2'b10;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'h12340000, 32'h00005678, 32'h12345678, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output Enable Low (Gated Output)", test_num);

            alu_opcode = 2'b00;
            immediate_1 = 32'd10;
            immediate_2 = 32'd10;
            input_register_selector_1 = 2'b00;
            input_register_selector_2 = 2'b00;
            output_enable = 1'b0;
            output_register_selector = 2'b11;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'd10, 32'd10, 32'd0, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Subtraction Result", test_num);

            alu_opcode = 2'b01;
            immediate_1 = 32'd5;
            immediate_2 = 32'd10;
            input_register_selector_1 = 2'b01;
            input_register_selector_2 = 2'b10;
            output_enable = 1'b1;
            output_register_selector = 2'b00;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'd5, 32'd10, 32'hFFFFFFFB, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Addition (Overflow behavior)", test_num);

            alu_opcode = 2'b00;
            immediate_1 = 32'hFFFFFFFF;
            immediate_2 = 32'h00000001;
            input_register_selector_1 = 2'b11;
            input_register_selector_2 = 2'b11;
            output_enable = 1'b1;
            output_register_selector = 2'b01;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'hFFFFFFFF, 32'h00000001, 32'h00000000, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Result Check", test_num);

            alu_opcode = 2'b10;
            immediate_1 = 32'hAAAA5555;
            immediate_2 = 32'h5555AAAA;
            input_register_selector_1 = 2'b10;
            input_register_selector_2 = 2'b01;
            output_enable = 1'b1;
            output_register_selector = 2'b10;
            output_source_selector = 1'b0;


            #1;



            check_outputs(32'hAAAA5555, 32'h5555AAAA, 32'h00000000, 2'b10);
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
        input [31:0] expected_input_data_1;
        input [31:0] expected_input_data_2;
        input [31:0] expected_output_data;
        input [1:0] expected_output_register;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_input_data_1 === (expected_input_data_1 ^ input_data_1 ^ expected_input_data_1) &&
                expected_input_data_2 === (expected_input_data_2 ^ input_data_2 ^ expected_input_data_2) &&
                expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_output_register === (expected_output_register ^ output_register ^ expected_output_register)) begin
                $display("PASS");
                $display("  Outputs: input_data_1=%h, input_data_2=%h, output_data=%h, output_register=%h",
                         input_data_1, input_data_2, output_data, output_register);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input_data_1=%h, input_data_2=%h, output_data=%h, output_register=%h",
                         expected_input_data_1, expected_input_data_2, expected_output_data, expected_output_register);
                $display("  Got:      input_data_1=%h, input_data_2=%h, output_data=%h, output_register=%h",
                         input_data_1, input_data_2, output_data, output_register);
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
