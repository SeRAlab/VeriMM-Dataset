`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Flush;
    reg WriteEnable;
    reg clock;
    reg [31:0] instruction;
    reg [31:0] pc_plus_four;
    wire [31:0] ID_instruction;
    wire [31:0] ID_pc_plus_four;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Flush(Flush),
        .WriteEnable(WriteEnable),
        .clock(clock),
        .instruction(instruction),
        .pc_plus_four(pc_plus_four),
        .ID_instruction(ID_instruction),
        .ID_pc_plus_four(ID_pc_plus_four)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            Flush = 1;
            WriteEnable = 0;
            pc_plus_four = 0;
            instruction = 0;
            @(posedge clock);
            #1;
            Flush = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write", test_num);
            reset_dut();

            WriteEnable = 1;
            Flush = 0;
            pc_plus_four = 32'h00000004;
            instruction = 32'h014B4820;

            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h014B4820, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: WriteEnable Disable (Data Hold)", test_num);
            reset_dut();


            WriteEnable = 1;
            pc_plus_four = 32'h00000008;
            instruction = 32'h8C490000;
            @(posedge clock);
            #2;


            WriteEnable = 0;
            pc_plus_four = 32'h0000000C;
            instruction = 32'h00000000;
            @(posedge clock);
            #2;


            #1;



            check_outputs(32'h8C490000, 32'h00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Flush Operation", test_num);
            reset_dut();


            WriteEnable = 1;
            pc_plus_four = 32'h00000010;
            instruction = 32'hAD490004;
            @(posedge clock);
            #2;


            Flush = 1;
            @(posedge clock);
            #2;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Flush Priority over WriteEnable", test_num);
            reset_dut();


            Flush = 1;
            WriteEnable = 1;
            pc_plus_four = 32'h00000020;
            instruction = 32'h08000005;

            @(posedge clock);
            #2;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Rapid Write Sequence", test_num);
            reset_dut();

            WriteEnable = 1;


            pc_plus_four = 32'hA;
            instruction = 32'hB;
            @(posedge clock);
            #2;


            pc_plus_four = 32'hC;
            instruction = 32'hD;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'hD, 32'hC);
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
        input [31:0] expected_ID_instruction;
        input [31:0] expected_ID_pc_plus_four;
        begin
            if (expected_ID_instruction === (expected_ID_instruction ^ ID_instruction ^ expected_ID_instruction) &&
                expected_ID_pc_plus_four === (expected_ID_pc_plus_four ^ ID_pc_plus_four ^ expected_ID_pc_plus_four)) begin
                $display("PASS");
                $display("  Outputs: ID_instruction=%h, ID_pc_plus_four=%h",
                         ID_instruction, ID_pc_plus_four);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_instruction=%h, ID_pc_plus_four=%h",
                         expected_ID_instruction, expected_ID_pc_plus_four);
                $display("  Got:      ID_instruction=%h, ID_pc_plus_four=%h",
                         ID_instruction, ID_pc_plus_four);
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
        $dumpvars(0,Flush, WriteEnable, clock, instruction, pc_plus_four, ID_instruction, ID_pc_plus_four);
    end

endmodule
