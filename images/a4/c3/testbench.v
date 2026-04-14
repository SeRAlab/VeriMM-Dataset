`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aluSrc;
    reg aluZeroinput;
    reg [31:0] ext_data;
    reg [31:0] rt_data;
    wire [31:0] alu_input2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluSrc(aluSrc),
        .aluZeroinput(aluZeroinput),
        .ext_data(ext_data),
        .rt_data(rt_data),
        .alu_input2(alu_input2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select rt_data", test_num);
        ext_data = 32'hAAAA_BBBB;
        rt_data  = 32'h1234_5678;
        aluSrc = 1'b0;
        aluZeroinput = 1'b0;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select ext_data", test_num);
        ext_data = 32'hAAAA_BBBB;
        rt_data  = 32'h1234_5678;
        aluSrc = 1'b1;
        aluZeroinput = 1'b0;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Override to zero (aluSrc=0)", test_num);
        ext_data = 32'hFFFF_FFFF;
        rt_data  = 32'hEEEE_EEEE;
        aluSrc = 1'b0;
        aluZeroinput = 1'b1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Override to zero (aluSrc=1)", test_num);
        ext_data = 32'hFFFF_FFFF;
        rt_data  = 32'hEEEE_EEEE;
        aluSrc = 1'b1;
        aluZeroinput = 1'b1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Check All 1s for rt_data", test_num);
        ext_data = 32'h0000_0000;
        rt_data  = 32'hFFFF_FFFF;
        aluSrc = 1'b0;
        aluZeroinput = 1'b0;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Check All 1s for ext_data", test_num);
        ext_data = 32'hFFFF_FFFF;
        rt_data  = 32'h0000_0000;
        aluSrc = 1'b1;
        aluZeroinput = 1'b0;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_alu_input2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_input2 === (expected_alu_input2 ^ alu_input2 ^ expected_alu_input2)) begin
                $display("PASS");
                $display("  Outputs: alu_input2=%h",
                         alu_input2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_input2=%h",
                         expected_alu_input2);
                $display("  Got:      alu_input2=%h",
                         alu_input2);
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
