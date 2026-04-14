`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Imediato;
    reg [31:0] MEM_out;
    reg [31:0] Reg_B_info;
    reg [1:0] Shift_Amt;
    wire [4:0] Shift_Amt_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Imediato(Imediato),
        .MEM_out(MEM_out),
        .Reg_B_info(Reg_B_info),
        .Shift_Amt(Shift_Amt),
        .Shift_Amt_out(Shift_Amt_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Reg_B_info[4:0]", test_num);
            Shift_Amt = 2'b00;
            Reg_B_info = 32'hA5A5_A512;
            Imediato = 16'hFFFF;
            MEM_out = 32'hFFFF_FFFF;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Imediato[10:6]", test_num);
            Shift_Amt = 2'b01;
            Reg_B_info = 32'h0000_0000;

            Imediato = 16'b0000_0110_1000_0000;
            MEM_out = 32'h0000_0000;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select MEM_out[4:0]", test_num);
            Shift_Amt = 2'b10;
            Reg_B_info = 32'hFFFF_FFFF;
            Imediato = 16'hFFFF;
            MEM_out = 32'h1234_5607;
            #1;

            check_outputs(5'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reg_B_info max value", test_num);
            Shift_Amt = 2'b00;
            Reg_B_info = 32'hFFFF_FFFF;
            Imediato = 16'h0000;
            MEM_out = 32'h0000_0000;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM_out zero value", test_num);
            Shift_Amt = 2'b10;
            Reg_B_info = 32'hFFFF_FFFF;
            Imediato = 16'hFFFF;
            MEM_out = 32'hFFFF_FFE0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Imediato pattern check", test_num);
            Shift_Amt = 2'b01;
            Reg_B_info = 32'h0;

            Imediato = 16'h0040;
            MEM_out = 32'h0;
            #1;

            check_outputs(5'h01);
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
        input [4:0] expected_Shift_Amt_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Shift_Amt_out === (expected_Shift_Amt_out ^ Shift_Amt_out ^ expected_Shift_Amt_out)) begin
                $display("PASS");
                $display("  Outputs: Shift_Amt_out=%h",
                         Shift_Amt_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Shift_Amt_out=%h",
                         expected_Shift_Amt_out);
                $display("  Got:      Shift_Amt_out=%h",
                         Shift_Amt_out);
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
