`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] instruction;
    wire [1:0] fld_affect;
    wire [4:0] fld_field0;
    wire [4:0] fld_field1;
    wire [4:0] fld_field2;
    wire [15:0] fld_immediate;
    wire [5:0] fld_opcode;
    wire [4:0] fld_shamt_I;
    wire [4:0] fld_shamt_R;
    wire [4:0] fld_shamt_S;
    wire fld_shift_IR;
    wire [1:0] fld_shift_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .fld_affect(fld_affect),
        .fld_field0(fld_field0),
        .fld_field1(fld_field1),
        .fld_field2(fld_field2),
        .fld_immediate(fld_immediate),
        .fld_opcode(fld_opcode),
        .fld_shamt_I(fld_shamt_I),
        .fld_shamt_R(fld_shamt_R),
        .fld_shamt_S(fld_shamt_S),
        .fld_shift_IR(fld_shift_IR),
        .fld_shift_type(fld_shift_type)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            instruction = 32'h0000_0000;

            #1;


            check_outputs(2'h0, 5'h00, 5'h00, 5'h00, 16'h0000, 6'h00, 5'h00, 5'h00, 5'h00, 1'b0, 2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            instruction = 32'hFFFF_FFFF;

            #1;


            check_outputs(2'h3, 5'h1F, 5'h1F, 5'h1F, 16'hFFFF, 6'h3F, 5'h1F, 5'h1F, 5'h1F, 1'b1, 2'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x12345678", test_num);
            instruction = 32'h1234_5678;





            #1;






            check_outputs(2'h0, 5'h11, 5'h14, 5'h0A, 16'h5678, 6'h04, 5'h11, 5'h14, 5'h19, 1'b0, 2'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0xABCDEF01", test_num);
            instruction = 32'hABCD_EF01;





            #1;






            check_outputs(2'h2, 5'h1E, 5'h0D, 5'h1E, 16'hEF01, 6'h2A, 5'h1E, 5'h0D, 5'h1C, 1'b0, 2'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0x55555555", test_num);
            instruction = 32'h5555_5555;





            #1;






            check_outputs(2'h1, 5'h0A, 5'h15, 5'h0A, 16'h5555, 6'h15, 5'h0A, 5'h15, 5'h15, 1'b1, 2'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 0xAAAAAAAA", test_num);
            instruction = 32'hAAAA_AAAA;





            #1;






            check_outputs(2'h2, 5'h15, 5'h0A, 5'h15, 16'hAAAA, 6'h2A, 5'h15, 5'h0A, 5'h0A, 1'b0, 2'h2);
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
        input [1:0] expected_fld_affect;
        input [4:0] expected_fld_field0;
        input [4:0] expected_fld_field1;
        input [4:0] expected_fld_field2;
        input [15:0] expected_fld_immediate;
        input [5:0] expected_fld_opcode;
        input [4:0] expected_fld_shamt_I;
        input [4:0] expected_fld_shamt_R;
        input [4:0] expected_fld_shamt_S;
        input expected_fld_shift_IR;
        input [1:0] expected_fld_shift_type;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fld_affect === (expected_fld_affect ^ fld_affect ^ expected_fld_affect) &&
                expected_fld_field0 === (expected_fld_field0 ^ fld_field0 ^ expected_fld_field0) &&
                expected_fld_field1 === (expected_fld_field1 ^ fld_field1 ^ expected_fld_field1) &&
                expected_fld_field2 === (expected_fld_field2 ^ fld_field2 ^ expected_fld_field2) &&
                expected_fld_immediate === (expected_fld_immediate ^ fld_immediate ^ expected_fld_immediate) &&
                expected_fld_opcode === (expected_fld_opcode ^ fld_opcode ^ expected_fld_opcode) &&
                expected_fld_shamt_I === (expected_fld_shamt_I ^ fld_shamt_I ^ expected_fld_shamt_I) &&
                expected_fld_shamt_R === (expected_fld_shamt_R ^ fld_shamt_R ^ expected_fld_shamt_R) &&
                expected_fld_shamt_S === (expected_fld_shamt_S ^ fld_shamt_S ^ expected_fld_shamt_S) &&
                expected_fld_shift_IR === (expected_fld_shift_IR ^ fld_shift_IR ^ expected_fld_shift_IR) &&
                expected_fld_shift_type === (expected_fld_shift_type ^ fld_shift_type ^ expected_fld_shift_type)) begin
                $display("PASS");
                $display("  Outputs: fld_affect=%h, fld_field0=%h, fld_field1=%h, fld_field2=%h, fld_immediate=%h, fld_opcode=%h, fld_shamt_I=%h, fld_shamt_R=%h, fld_shamt_S=%h, fld_shift_IR=%b, fld_shift_type=%h",
                         fld_affect, fld_field0, fld_field1, fld_field2, fld_immediate, fld_opcode, fld_shamt_I, fld_shamt_R, fld_shamt_S, fld_shift_IR, fld_shift_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fld_affect=%h, fld_field0=%h, fld_field1=%h, fld_field2=%h, fld_immediate=%h, fld_opcode=%h, fld_shamt_I=%h, fld_shamt_R=%h, fld_shamt_S=%h, fld_shift_IR=%b, fld_shift_type=%h",
                         expected_fld_affect, expected_fld_field0, expected_fld_field1, expected_fld_field2, expected_fld_immediate, expected_fld_opcode, expected_fld_shamt_I, expected_fld_shamt_R, expected_fld_shamt_S, expected_fld_shift_IR, expected_fld_shift_type);
                $display("  Got:      fld_affect=%h, fld_field0=%h, fld_field1=%h, fld_field2=%h, fld_immediate=%h, fld_opcode=%h, fld_shamt_I=%h, fld_shamt_R=%h, fld_shamt_S=%h, fld_shift_IR=%b, fld_shift_type=%h",
                         fld_affect, fld_field0, fld_field1, fld_field2, fld_immediate, fld_opcode, fld_shamt_I, fld_shamt_R, fld_shamt_S, fld_shift_IR, fld_shift_type);
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
