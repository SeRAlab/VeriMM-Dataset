`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] IF_PC;
    reg [31:0] IF_instruction;
    reg RST;
    reg flush;
    reg stall;
    wire [31:0] ID_PC;
    wire [31:0] ID_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IF_PC(IF_PC),
        .IF_instruction(IF_instruction),
        .RST(RST),
        .flush(flush),
        .stall(stall),
        .ID_PC(ID_PC),
        .ID_instruction(ID_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            stall = 0;
            flush = 0;
            IF_PC = 32'h0;
            IF_instruction = 32'h0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Data Propagation", test_num);
            reset_dut();

            IF_PC = 32'h0000_1000;
            IF_instruction = 32'hADDE_BEEF;
            stall = 0;
            flush = 0;

            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'h0000_1000, 32'hADDE_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Stall behavior", test_num);
            reset_dut();


            IF_PC = 32'h0000_2000;
            IF_instruction = 32'h1111_1111;
            @(posedge CLK);
            #1;


            stall = 1;
            IF_PC = 32'h0000_3000;
            IF_instruction = 32'h2222_2222;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'h0000_2000, 32'h1111_1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Flush behavior", test_num);
            reset_dut();


            IF_PC = 32'h0000_4000;
            IF_instruction = 32'hCAFE_BABE;
            @(posedge CLK);
            #1;


            flush = 1;
            IF_PC = 32'h0000_5000;
            IF_instruction = 32'hDDDD_DDDD;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'h0000_4000, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Combined Stall and Flush", test_num);
            reset_dut();


            IF_PC = 32'h0000_6000;
            IF_instruction = 32'h6666_6666;
            @(posedge CLK);
            #1;


            stall = 1;
            flush = 1;
            IF_PC = 32'h0000_7000;
            IF_instruction = 32'h7777_7777;

            @(posedge CLK);
            #2;



            #1;




            check_outputs(32'h0000_6000, 32'h6666_6666);
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
        input [31:0] expected_ID_PC;
        input [31:0] expected_ID_instruction;
        begin
            if (expected_ID_PC === (expected_ID_PC ^ ID_PC ^ expected_ID_PC) &&
                expected_ID_instruction === (expected_ID_instruction ^ ID_instruction ^ expected_ID_instruction)) begin
                $display("PASS");
                $display("  Outputs: ID_PC=%h, ID_instruction=%h",
                         ID_PC, ID_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_PC=%h, ID_instruction=%h",
                         expected_ID_PC, expected_ID_instruction);
                $display("  Got:      ID_PC=%h, ID_instruction=%h",
                         ID_PC, ID_instruction);
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
        $dumpvars(0,CLK, IF_PC, IF_instruction, RST, flush, stall, ID_PC, ID_instruction);
    end

endmodule
