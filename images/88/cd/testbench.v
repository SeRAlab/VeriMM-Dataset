`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [20:0] Instruction_EX;
    reg RegDst_EX;
    wire [4:0] Write_Register_EX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Instruction_EX(Instruction_EX),
        .RegDst_EX(RegDst_EX),
        .Write_Register_EX(Write_Register_EX)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst_EX = 1 selects bits [15:11] (R-type)", test_num);

            Instruction_EX = 21'b00000_10101_00000000000;
            RegDst_EX = 1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst_EX = 0 selects bits [20:16] (I-type)", test_num);

            Instruction_EX = 21'b11011_00000_00000000000;
            RegDst_EX = 0;
            #1;

            check_outputs(5'h1B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values - All ones Instruction with RegDst_EX = 1", test_num);
            Instruction_EX = 21'h1FFFFF;
            RegDst_EX = 1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values - All zeros Instruction with RegDst_EX = 0", test_num);
            Instruction_EX = 21'h000000;
            RegDst_EX = 0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns", test_num);

            Instruction_EX = 21'b10101_01010_11111111111;


            RegDst_EX = 0;
            #1;

            check_outputs(5'h15);


            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns - Switching to RegDst_EX = 1", test_num);
            RegDst_EX = 1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random bit verification", test_num);

            Instruction_EX = 21'h07C000;



            RegDst_EX = 0;
            #1;

            check_outputs(5'h07);
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
        input [4:0] expected_Write_Register_EX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Write_Register_EX === (expected_Write_Register_EX ^ Write_Register_EX ^ expected_Write_Register_EX)) begin
                $display("PASS");
                $display("  Outputs: Write_Register_EX=%h",
                         Write_Register_EX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Write_Register_EX=%h",
                         expected_Write_Register_EX);
                $display("  Got:      Write_Register_EX=%h",
                         Write_Register_EX);
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
