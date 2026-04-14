`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Instr_Code;
    reg Reset;
    wire [7:0] IF_ID_Instr_Code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Instr_Code(Instr_Code),
        .Reset(Reset),
        .IF_ID_Instr_Code(IF_ID_Instr_Code)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 0;
            Instr_Code = 8'h00;
            @(posedge Clk);
            #1;
            Reset = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset functionality (Output should be 0)", test_num);
            Reset = 0;
            Instr_Code = 8'hFF;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Capture Pattern 0xAA", test_num);
            reset_dut();
            Instr_Code = 8'hAA;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Capture Pattern 0x55", test_num);
            reset_dut();
            Instr_Code = 8'h55;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Capture Pattern 0xFF", test_num);
            reset_dut();
            Instr_Code = 8'hFF;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Capture Pattern 0x00", test_num);
            reset_dut();
            Instr_Code = 8'h00;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Successive data capture", test_num);
            reset_dut();
            Instr_Code = 8'h12;
            @(posedge Clk);
            #1;
            Instr_Code = 8'h34;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h34);
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
        input [7:0] expected_IF_ID_Instr_Code;
        begin
            if (expected_IF_ID_Instr_Code === (expected_IF_ID_Instr_Code ^ IF_ID_Instr_Code ^ expected_IF_ID_Instr_Code)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_Instr_Code=%h",
                         IF_ID_Instr_Code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_Instr_Code=%h",
                         expected_IF_ID_Instr_Code);
                $display("  Got:      IF_ID_Instr_Code=%h",
                         IF_ID_Instr_Code);
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
        $dumpvars(0,Clk, Instr_Code, Reset, IF_ID_Instr_Code);
    end

endmodule
