`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] L;
    reg [6:0] aluOp;
    reg aluSrc;
    reg branch;
    reg [14:0] imm_addr;
    reg [19:0] immediate;
    reg memRead;
    reg [31:0] read_data1;
    reg [31:0] read_data2;
    wire [31:0] input1;
    wire [31:0] input2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .L(L),
        .aluOp(aluOp),
        .aluSrc(aluSrc),
        .branch(branch),
        .imm_addr(imm_addr),
        .immediate(immediate),
        .memRead(memRead),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .input1(input1),
        .input2(input2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: aluSrc=1 (Positive Immediate)", test_num);
            read_data1 = 32'hAAAA_BBBB;
            read_data2 = 32'h1234_5678;
            aluSrc = 1'b1;
            memRead = 1'b0;
            branch = 1'b0;
            immediate = 20'h7FFFF;
            imm_addr = 15'h1234;
            L = 25'h0;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h0007_FFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: aluSrc=1 (Negative Immediate)", test_num);
            read_data1 = 32'h0;
            immediate = 20'h80001;
            aluSrc = 1'b1;
            memRead = 1'b0;
            branch = 1'b0;
            #1;

            check_outputs(32'h0, 32'hFFF8_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: memRead=1 (Positive Address)", test_num);
            read_data1 = 32'h5555_6666;
            aluSrc = 1'b0;
            memRead = 1'b1;
            branch = 1'b0;
            imm_addr = 15'h3FFF;
            #1;

            check_outputs(32'h5555_6666, 32'h0000_3FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: memRead=1 (Negative Address)", test_num);
            aluSrc = 1'b0;
            memRead = 1'b1;
            branch = 1'b0;
            imm_addr = 15'h4000;
            #1;

            check_outputs(read_data1, 32'hFFFF_C000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: branch=1 (Positive L)", test_num);
            aluSrc = 1'b0;
            memRead = 1'b0;
            branch = 1'b1;
            L = 25'h0AAA_AAA;
            #1;

            check_outputs(read_data1, 32'h00AA_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: branch=1 (Negative L)", test_num);
            aluSrc = 1'b0;
            memRead = 1'b0;
            branch = 1'b1;
            L = 25'h100_0000;
            #1;

            check_outputs(read_data1, 32'hFF00_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All control signals 0 (Default to read_data2)", test_num);
            read_data1 = 32'h1111_2222;
            read_data2 = 32'hDDDD_EEEE;
            aluSrc = 1'b0;
            memRead = 1'b0;
            branch = 1'b0;
            #1;

            check_outputs(32'h1111_2222, 32'hDDDD_EEEE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (aluSrc vs memRead)", test_num);
            aluSrc = 1'b1;
            memRead = 1'b1;
            branch = 1'b1;
            immediate = 20'hABCDE;
            imm_addr = 15'h1234;
            L = 25'h0;

            #1;


            check_outputs(read_data1, 32'h000A_BCDE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (memRead vs branch)", test_num);
            aluSrc = 1'b0;
            memRead = 1'b1;
            branch = 1'b1;
            imm_addr = 15'h7FFF;
            L = 25'h1FFFFFF;

            #1;


            check_outputs(read_data1, 32'h0000_7FFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input1 constant check", test_num);
            read_data1 = 32'hDEAD_BEEF;
            aluSrc = 1'b0;
            memRead = 1'b0;
            branch = 1'b0;
            read_data2 = 32'hCAFE_BABE;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hCAFE_BABE);
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
        input [31:0] expected_input1;
        input [31:0] expected_input2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_input1 === (expected_input1 ^ input1 ^ expected_input1) &&
                expected_input2 === (expected_input2 ^ input2 ^ expected_input2)) begin
                $display("PASS");
                $display("  Outputs: input1=%h, input2=%h",
                         input1, input2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input1=%h, input2=%h",
                         expected_input1, expected_input2);
                $display("  Got:      input1=%h, input2=%h",
                         input1, input2);
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
