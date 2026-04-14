`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [1:0] ID;
    reg [31:0] PC;
    reg RE;
    reg RST;
    reg WE;
    wire [31:0] EPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ID(ID),
        .PC(PC),
        .RE(RE),
        .RST(RST),
        .WE(WE),
        .EPC(EPC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            WE = 0;
            RE = 0;
            ID = 0;
            PC = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Read Check", test_num);
            reset_dut();
            RE = 1;
            #1;
            #1;

            check_outputs(32'h00000000);
            RE = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PC Bypass Mode Check", test_num);
            reset_dut();
            PC = 32'hABCD1234;
            RE = 0;
            WE = 0;
            #1;
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Exception Vector ID 0 (108)", test_num);
            reset_dut();
            WE = 1;
            ID = 2'b00;
            #1;
            #1;

            check_outputs(32'd108);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Exception Vector ID 1 (120)", test_num);
            reset_dut();
            WE = 1;
            ID = 2'b01;
            #1;
            #1;

            check_outputs(32'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Exception Vector ID 2 (132)", test_num);
            reset_dut();
            WE = 1;
            ID = 2'b10;
            #1;
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Exception Vector ID 3 (144)", test_num);
            reset_dut();
            WE = 1;
            ID = 2'b11;
            #1;
            #1;

            check_outputs(32'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: PC Latched Value Retrieval", test_num);
            reset_dut();
            PC = 32'h55AA66BB;
            WE = 1;
            ID = 2'b00;
            @(posedge CLK);
            #1 WE = 0;
            RE = 1;
            #1;
            #1;

            check_outputs(32'h55AA66BB);
            RE = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Sequential PC Latches (Overwrite)", test_num);
            reset_dut();
            PC = 32'h11111111; WE = 1; @(posedge CLK);
            #1 PC = 32'h22222222; WE = 1; @(posedge CLK);
            #1 WE = 0; RE = 1;
            #1;
            #1;

            check_outputs(32'h22222222);
            RE = 0;
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
        input [31:0] expected_EPC;
        begin
            if (expected_EPC === (expected_EPC ^ EPC ^ expected_EPC)) begin
                $display("PASS");
                $display("  Outputs: EPC=%h",
                         EPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EPC=%h",
                         expected_EPC);
                $display("  Got:      EPC=%h",
                         EPC);
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
        $dumpvars(0,CLK, ID, PC, RE, RST, WE, EPC);
    end

endmodule
