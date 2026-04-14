`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PC;
    reg Reset;
    wire [7:0] Instruction_Code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .Reset(Reset),
        .Instruction_Code(Instruction_Code)
    );

    // Clock generation (10ns period)
    initial begin
        Reset = 0;
        forever #5 Reset = ~Reset;
    end

        task reset_dut;

        begin
            PC = 8'h00;


            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Access PC 0x00", test_num);
            reset_dut();
            PC = 8'h00;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Access PC 0x05", test_num);
            reset_dut();
            PC = 8'h05;
            #10;

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Access PC 0x0A", test_num);
            reset_dut();
            PC = 8'h0A;
            #10;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Access PC 0x0F (Max Index)", test_num);
            reset_dut();
            PC = 8'h0F;
            #10;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Access PC 0x10 (Out of Bounds)", test_num);
            reset_dut();
            PC = 8'h10;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid PC change", test_num);
            reset_dut();
            PC = 8'h03;
            #10;
            PC = 8'h07;
            #10;
            #1;

            check_outputs(8'h07);
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
        input [7:0] expected_Instruction_Code;
        begin
            if (expected_Instruction_Code === (expected_Instruction_Code ^ Instruction_Code ^ expected_Instruction_Code)) begin
                $display("PASS");
                $display("  Outputs: Instruction_Code=%h",
                         Instruction_Code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction_Code=%h",
                         expected_Instruction_Code);
                $display("  Got:      Instruction_Code=%h",
                         Instruction_Code);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,PC, Reset, Instruction_Code);
    end

endmodule
