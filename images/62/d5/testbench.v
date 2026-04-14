`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_out;
    reg [31:0] mem_out;
    reg mem_to_reg;
    wire [31:0] write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_out(alu_out),
        .mem_out(mem_out),
        .mem_to_reg(mem_to_reg),
        .write_data(write_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ALU Output (Normal Value)", test_num);
        alu_out = 32'h12345678;
        mem_out = 32'hABCDEF00;
        mem_to_reg = 0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Memory Output (Normal Value)", test_num);
        alu_out = 32'h12345678;
        mem_out = 32'hABCDEF00;
        mem_to_reg = 1;
        #1;

        check_outputs(32'hABCDEF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ALU (All Ones)", test_num);
        alu_out = 32'hFFFFFFFF;
        mem_out = 32'h00000000;
        mem_to_reg = 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Memory (All Ones)", test_num);
        alu_out = 32'h00000000;
        mem_out = 32'hFFFFFFFF;
        mem_to_reg = 1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ALU (Alternating Bits)", test_num);
        alu_out = 32'hAAAAAAAA;
        mem_out = 32'h55555555;
        mem_to_reg = 0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Memory (Alternating Bits)", test_num);
        alu_out = 32'hAAAAAAAA;
        mem_out = 32'h55555555;
        mem_to_reg = 1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both inputs Zero", test_num);
        alu_out = 32'h00000000;
        mem_out = 32'h00000000;
        mem_to_reg = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle Select Signal", test_num);
        alu_out = 32'hCAFEFEED;
        mem_out = 32'hDEADBEEF;
        mem_to_reg = 1;
        #5;
        mem_to_reg = 0;
        #1;

        check_outputs(32'hCAFEFEED);
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
        input [31:0] expected_write_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_write_data === (expected_write_data ^ write_data ^ expected_write_data)) begin
                $display("PASS");
                $display("  Outputs: write_data=%h",
                         write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_data=%h",
                         expected_write_data);
                $display("  Got:      write_data=%h",
                         write_data);
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
