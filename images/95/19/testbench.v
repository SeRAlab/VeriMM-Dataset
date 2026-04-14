`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALU_result;
    reg MEMtoReg;
    reg [31:0] load_data;
    wire [31:0] write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_result(ALU_result),
        .MEMtoReg(MEMtoReg),
        .load_data(load_data),
        .write_data(write_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select ALU_result (MEMtoReg = 0)", test_num);
        MEMtoReg = 1'b0;
        ALU_result = 32'hDEADBEEF;
        load_data = 32'hCAFEBABE;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select load_data (MEMtoReg = 1)", test_num);
        MEMtoReg = 1'b1;
        ALU_result = 32'hDEADBEEF;
        load_data = 32'hCAFEBABE;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Boundary - All Zeros", test_num);
        MEMtoReg = 1'b0;
        ALU_result = 32'h00000000;
        load_data = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Boundary - All Ones", test_num);
        MEMtoReg = 1'b1;
        ALU_result = 32'h00000000;
        load_data = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits pattern", test_num);
        MEMtoReg = 1'b0;
        ALU_result = 32'hAAAAAAAA;
        load_data = 32'h55555555;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits pattern (Switch)", test_num);
        MEMtoReg = 1'b1;
        ALU_result = 32'hAAAAAAAA;
        load_data = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
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
