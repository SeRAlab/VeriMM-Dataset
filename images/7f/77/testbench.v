`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA;
    reg [7:0] INSTR;
    reg RESET;
    wire FLAG;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .INSTR(INSTR),
        .RESET(RESET),
        .FLAG(FLAG),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            INSTR = NOP;
            DATA = 8'h00;
            @(posedge CLK);
            #1 RESET = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: MOV Operation");
            reset_dut();
            INSTR = MOV;
            DATA  = 8'h55;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: ADD Operation (0x10 + 0x25)");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'h10;
            @(posedge CLK);

            #1 INSTR = ADD;
            DATA  = 8'h25;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 8'h35);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: SUB Operation (0x20 - 0x05)");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'h20;
            @(posedge CLK);

            #1 INSTR = SUB;
            DATA  = 8'h05;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 8'h1B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: CMP Operation (Equal)");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'hAA;
            @(posedge CLK);

            #1 INSTR = CMP;
            DATA  = 8'hAA;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: CMP Operation (Not Equal)");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'hAA;
            @(posedge CLK);

            #1 INSTR = CMP;
            DATA  = 8'hBB;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: NOP Operation");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'h12;
            @(posedge CLK);

            #1 INSTR = NOP;
            DATA  = 8'hFF;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: HLT Operation");
            reset_dut();

            INSTR = MOV;
            DATA  = 8'hCC;
            @(posedge CLK);

            #1 INSTR = HLT;
            @(posedge CLK);

            #1 INSTR = MOV;
            DATA  = 8'hDD;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 8'hCC);
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
        testcase007();
        testcase008();
        
        
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
        input expected_FLAG;
        input [7:0] expected_OUT;
        begin
            if (expected_FLAG === (expected_FLAG ^ FLAG ^ expected_FLAG) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: FLAG=%b, OUT=%h",
                         FLAG, OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAG=%b, OUT=%h",
                         expected_FLAG, expected_OUT);
                $display("  Got:      FLAG=%b, OUT=%h",
                         FLAG, OUT);
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
        $dumpvars(0,CLK, DATA, INSTR, RESET, FLAG, OUT);
    end

endmodule
