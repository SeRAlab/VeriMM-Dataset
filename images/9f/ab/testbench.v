`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IF_ID_Hold;
    reg clock;
    reg [19:0] instruction;
    reg reset;
    wire [19:0] instructionPropagation;
    wire [3:0] opA;
    wire [3:0] opB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IF_ID_Hold(IF_ID_Hold),
        .clock(clock),
        .instruction(instruction),
        .reset(reset),
        .instructionPropagation(instructionPropagation),
        .opA(opA),
        .opB(opB)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            IF_ID_Hold = 0;
            instruction = 20'h0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Instruction Propagation", test_num);
            reset_dut();


            instruction = 20'hA5C31;
            IF_ID_Hold = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(20'hA5C31, 4'hC, 4'h3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold Functionality", test_num);
            reset_dut();


            instruction = 20'h12345;
            IF_ID_Hold = 0;
            @(posedge clock);
            #2;


            IF_ID_Hold = 1;
            instruction = 20'hFFFFF;
            @(posedge clock);
            #2;



            #1;




            check_outputs(20'h12345, 4'h3, 4'h4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();

            instruction = 20'hABCDE;
            IF_ID_Hold = 0;
            @(posedge clock);
            #2;


            reset = 1;
            @(posedge clock);
            #2;


            #1;



            check_outputs(20'h00000, 4'h0, 4'h0);
            reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Recovery from Hold", test_num);
            reset_dut();


            instruction = 20'h55555;
            IF_ID_Hold = 0;
            @(posedge clock);
            #2;


            IF_ID_Hold = 1;
            instruction = 20'hAAAAA;
            @(posedge clock);
            #2;


            IF_ID_Hold = 0;
            instruction = 20'h98765;
            @(posedge clock);
            #2;


            #1;



            check_outputs(20'h98765, 4'h7, 4'h6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high propagation", test_num);
            reset_dut();

            instruction = 20'hFFFFF;
            IF_ID_Hold = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(20'hFFFFF, 4'hF, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Continuous Flow", test_num);
            reset_dut();

            instruction = 20'h11111;
            @(posedge clock);
            #2;

            instruction = 20'h22222;
            @(posedge clock);
            #2;

            instruction = 20'h33333;
            @(posedge clock);
            #2;

            #1;


            check_outputs(20'h33333, 4'h3, 4'h3);
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
        input [19:0] expected_instructionPropagation;
        input [3:0] expected_opA;
        input [3:0] expected_opB;
        begin
            if (expected_instructionPropagation === (expected_instructionPropagation ^ instructionPropagation ^ expected_instructionPropagation) &&
                expected_opA === (expected_opA ^ opA ^ expected_opA) &&
                expected_opB === (expected_opB ^ opB ^ expected_opB)) begin
                $display("PASS");
                $display("  Outputs: instructionPropagation=%h, opA=%h, opB=%h",
                         instructionPropagation, opA, opB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instructionPropagation=%h, opA=%h, opB=%h",
                         expected_instructionPropagation, expected_opA, expected_opB);
                $display("  Got:      instructionPropagation=%h, opA=%h, opB=%h",
                         instructionPropagation, opA, opB);
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
        $dumpvars(0,IF_ID_Hold, clock, instruction, reset, instructionPropagation, opA, opB);
    end

endmodule
