`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [19:0] instruction;
    reg [19:0] read_data1;
    reg [19:0] read_data2;
    reg reset;
    wire [3:0] ID_EX_op1;
    wire [3:0] ID_EX_op2;
    wire [19:0] dataRFOut1;
    wire [19:0] dataRFOut2;
    wire [19:0] instructionPropagation;
    wire [3:0] opDestino;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .instruction(instruction),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .reset(reset),
        .ID_EX_op1(ID_EX_op1),
        .ID_EX_op2(ID_EX_op2),
        .dataRFOut1(dataRFOut1),
        .dataRFOut2(dataRFOut2),
        .instructionPropagation(instructionPropagation),
        .opDestino(opDestino)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            instruction = 0;
            read_data1 = 0;
            read_data2 = 0;
            @(negedge clock);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state initialization", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 20'h0, 20'h0, 20'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic propagation of data and opcode segments", test_num);
            reset_dut();
            instruction = 20'hA5C31;
            read_data1  = 20'h12345;
            read_data2  = 20'h6789A;
            @(posedge clock);
            #2;
            #1;

            check_outputs(4'hC, 4'h3, 20'h12345, 20'h6789A, 20'hA5C31, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing propagation with all bits set", test_num);
            reset_dut();
            instruction = 20'hFFFFF;
            read_data1  = 20'hFFFFF;
            read_data2  = 20'hFFFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(4'hF, 4'hF, 20'hFFFFF, 20'hFFFFF, 20'hFFFFF, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying sequential update across clock cycles", test_num);
            reset_dut();

            instruction = 20'h12345;
            read_data1  = 20'hAAAAA;
            read_data2  = 20'hBBBBB;
            @(posedge clock);
            #1;

            instruction = 20'h67890;
            read_data1  = 20'hCCCCC;
            read_data2  = 20'hDDDDD;
            @(posedge clock);
            #2;

            #1;


            check_outputs(4'h8, 4'h9, 20'hCCCCC, 20'hDDDDD, 20'h67890, 4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying reset priority while data is present", test_num);
            reset_dut();

            instruction = 20'hABCDE;
            read_data1  = 20'h11111;
            read_data2  = 20'h22222;
            @(posedge clock);
            #1;

            reset = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(4'h0, 4'h0, 20'h0, 20'h0, 20'h0, 4'h0);
            reset = 0;
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
        input [3:0] expected_ID_EX_op1;
        input [3:0] expected_ID_EX_op2;
        input [19:0] expected_dataRFOut1;
        input [19:0] expected_dataRFOut2;
        input [19:0] expected_instructionPropagation;
        input [3:0] expected_opDestino;
        begin
            if (expected_ID_EX_op1 === (expected_ID_EX_op1 ^ ID_EX_op1 ^ expected_ID_EX_op1) &&
                expected_ID_EX_op2 === (expected_ID_EX_op2 ^ ID_EX_op2 ^ expected_ID_EX_op2) &&
                expected_dataRFOut1 === (expected_dataRFOut1 ^ dataRFOut1 ^ expected_dataRFOut1) &&
                expected_dataRFOut2 === (expected_dataRFOut2 ^ dataRFOut2 ^ expected_dataRFOut2) &&
                expected_instructionPropagation === (expected_instructionPropagation ^ instructionPropagation ^ expected_instructionPropagation) &&
                expected_opDestino === (expected_opDestino ^ opDestino ^ expected_opDestino)) begin
                $display("PASS");
                $display("  Outputs: ID_EX_op1=%h, ID_EX_op2=%h, dataRFOut1=%h, dataRFOut2=%h, instructionPropagation=%h, opDestino=%h",
                         ID_EX_op1, ID_EX_op2, dataRFOut1, dataRFOut2, instructionPropagation, opDestino);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_EX_op1=%h, ID_EX_op2=%h, dataRFOut1=%h, dataRFOut2=%h, instructionPropagation=%h, opDestino=%h",
                         expected_ID_EX_op1, expected_ID_EX_op2, expected_dataRFOut1, expected_dataRFOut2, expected_instructionPropagation, expected_opDestino);
                $display("  Got:      ID_EX_op1=%h, ID_EX_op2=%h, dataRFOut1=%h, dataRFOut2=%h, instructionPropagation=%h, opDestino=%h",
                         ID_EX_op1, ID_EX_op2, dataRFOut1, dataRFOut2, instructionPropagation, opDestino);
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
        $dumpvars(0,clock, instruction, read_data1, read_data2, reset, ID_EX_op1, ID_EX_op2, dataRFOut1, dataRFOut2, instructionPropagation, opDestino);
    end

endmodule
