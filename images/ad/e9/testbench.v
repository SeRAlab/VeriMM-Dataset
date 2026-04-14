`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALU_result;
    reg mem_to_reg;
    reg [31:0] read_mem_data;
    wire [31:0] WB_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_result(ALU_result),
        .mem_to_reg(mem_to_reg),
        .read_mem_data(read_mem_data),
        .WB_result(WB_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select ALU_result (mem_to_reg = 0)", test_num);
            ALU_result = 32'h12345678;
            read_mem_data = 32'hABCDEF00;
            mem_to_reg = 0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select read_mem_data (mem_to_reg = 1)", test_num);
            ALU_result = 32'h12345678;
            read_mem_data = 32'hABCDEF00;
            mem_to_reg = 1;
            #1;

            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select ALU_result with all ones", test_num);
            ALU_result = 32'hFFFFFFFF;
            read_mem_data = 32'h00000000;
            mem_to_reg = 0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select read_mem_data with all ones", test_num);
            ALU_result = 32'h00000000;
            read_mem_data = 32'hFFFFFFFF;
            mem_to_reg = 1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select ALU_result with alternating pattern", test_num);
            ALU_result = 32'h55555555;
            read_mem_data = 32'hAAAAAAAA;
            mem_to_reg = 0;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select read_mem_data with alternating pattern", test_num);
            ALU_result = 32'h55555555;
            read_mem_data = 32'hAAAAAAAA;
            mem_to_reg = 1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select ALU_result with specific hex values", test_num);
            ALU_result = 32'hDEADBEEF;
            read_mem_data = 32'hCAFEBABE;
            mem_to_reg = 0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select read_mem_data with specific hex values", test_num);
            ALU_result = 32'hDEADBEEF;
            read_mem_data = 32'hCAFEBABE;
            mem_to_reg = 1;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_WB_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WB_result === (expected_WB_result ^ WB_result ^ expected_WB_result)) begin
                $display("PASS");
                $display("  Outputs: WB_result=%h",
                         WB_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_result=%h",
                         expected_WB_result);
                $display("  Got:      WB_result=%h",
                         WB_result);
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
