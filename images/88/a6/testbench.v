`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] IM_Address;
    reg clk;
    reg rst;
    wire [31:0] Instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IM_Address(IM_Address),
        .clk(clk),
        .rst(rst),
        .Instruction(Instruction)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset and Read Address 0x0000", test_num);
            rst = 1;
            IM_Address = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(dut.mem[16'h0000]);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 0x0001", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            IM_Address = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.mem[16'h0001]);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 0x0004", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            IM_Address = 16'h0004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.mem[16'h0004]);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Address 0x00FF", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            IM_Address = 16'h00FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.mem[16'h00FF]);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Read Maximum Address 0xFFFF", test_num);
            rst = 1;
            @(posedge clk);
            rst = 0;
            IM_Address = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.mem[16'hFFFF]);
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
        input [31:0] expected_Instruction;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Instruction === (expected_Instruction ^ Instruction ^ expected_Instruction)) begin
                $display("PASS");
                $display("  Outputs: Instruction=%h",
                         Instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction=%h",
                         expected_Instruction);
                $display("  Got:      Instruction=%h",
                         Instruction);
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
