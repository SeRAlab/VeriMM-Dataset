`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_v;
    reg [31:0] mem_v;
    reg memread;
    wire [31:0] reg_write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_v(alu_v),
        .mem_v(mem_v),
        .memread(memread),
        .reg_write_data(reg_write_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select ALU Value (memread = 0)", test_num);
        alu_v = 32'hAAAA_AAAA;
        mem_v = 32'h5555_5555;
        memread = 1'b0;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Memory Value (memread = 1)", test_num);
        alu_v = 32'hAAAA_AAAA;
        mem_v = 32'h5555_5555;
        memread = 1'b1;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero/All-Ones Check - ALU", test_num);
        alu_v = 32'h0000_0000;
        mem_v = 32'hFFFF_FFFF;
        memread = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero/All-Ones Check - Memory", test_num);
        alu_v = 32'h0000_0000;
        mem_v = 32'hFFFF_FFFF;
        memread = 1'b1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Hex Values Selection", test_num);
        alu_v = 32'h1234_5678;
        mem_v = 32'h8765_4321;
        memread = 1'b0;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Hex Values Selection (Flip)", test_num);
        alu_v = 32'h1234_5678;
        mem_v = 32'h8765_4321;
        memread = 1'b1;
        #1;

        check_outputs(32'h8765_4321);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verification with specific bit pattern", test_num);
        alu_v = 32'hDEADBEEF;
        mem_v = 32'hCAFEBABE;
        memread = 1'b0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verification with specific bit pattern (Flip)", test_num);
        alu_v = 32'hDEADBEEF;
        mem_v = 32'hCAFEBABE;
        memread = 1'b1;
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
        input [31:0] expected_reg_write_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reg_write_data === (expected_reg_write_data ^ reg_write_data ^ expected_reg_write_data)) begin
                $display("PASS");
                $display("  Outputs: reg_write_data=%h",
                         reg_write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_write_data=%h",
                         expected_reg_write_data);
                $display("  Got:      reg_write_data=%h",
                         reg_write_data);
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
