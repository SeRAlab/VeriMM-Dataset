`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg mem_ALU_select;
    reg [31:0] mem_result;
    reg rst_n;
    reg [31:0] sprite_ALU_result;
    wire [31:0] reg_WB_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_ALU_select(mem_ALU_select),
        .mem_result(mem_result),
        .rst_n(rst_n),
        .sprite_ALU_result(sprite_ALU_result),
        .reg_WB_data(reg_WB_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Sprite ALU Result (mem_ALU_select = 0)", test_num);

            rst_n = 0;
            mem_result = 32'hBAAD_F00D;
            sprite_ALU_result = 32'h1234_5678;
            mem_ALU_select = 0;
            #10 rst_n = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Memory Result (mem_ALU_select = 1)", test_num);

            rst_n = 0;
            mem_result = 32'hABCD_EF01;
            sprite_ALU_result = 32'hFFFF_FFFF;
            mem_ALU_select = 1;
            #10 rst_n = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hABCD_EF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify ALU selection with different data pattern", test_num);

            rst_n = 0;
            mem_result = 32'h0000_0000;
            sprite_ALU_result = 32'h5555_AAAA;
            mem_ALU_select = 0;
            #10 rst_n = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Memory selection with all ones", test_num);

            rst_n = 0;
            mem_result = 32'hFFFF_FFFF;
            sprite_ALU_result = 32'h0000_0000;
            mem_ALU_select = 1;
            #10 rst_n = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check immunity of ALU selection to Memory input changes", test_num);

            rst_n = 0;
            mem_result = 32'h1111_1111;
            sprite_ALU_result = 32'hCAFE_BABE;
            mem_ALU_select = 0;
            #10 rst_n = 1;


            @(posedge clk);
            mem_result = 32'hEEEE_EEEE;
            #10;

            #1;


            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check immunity of Memory selection to ALU input changes", test_num);

            rst_n = 0;
            mem_result = 32'h8888_8888;
            sprite_ALU_result = 32'h2222_2222;
            mem_ALU_select = 1;
            #10 rst_n = 1;


            @(posedge clk);
            sprite_ALU_result = 32'h3333_3333;
            #10;

            #1;


            check_outputs(32'h8888_8888);
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
        input [31:0] expected_reg_WB_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_WB_data === (expected_reg_WB_data ^ reg_WB_data ^ expected_reg_WB_data)) begin
                $display("PASS");
                $display("  Outputs: reg_WB_data=%h",
                         reg_WB_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_WB_data=%h",
                         expected_reg_WB_data);
                $display("  Got:      reg_WB_data=%h",
                         reg_WB_data);
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
