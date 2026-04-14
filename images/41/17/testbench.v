`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DualWrite;
    reg RegWrite;
    reg [31:0] Wdat;
    reg clk;
    reg [4:0] regA;
    reg [4:0] regB;
    reg [4:0] regTEST;
    reg [4:0] regW;
    reg resetn;
    wire [31:0] Adat;
    wire [31:0] Bdat;
    wire [31:0] TESTdat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DualWrite(DualWrite),
        .RegWrite(RegWrite),
        .Wdat(Wdat),
        .clk(clk),
        .regA(regA),
        .regB(regB),
        .regTEST(regTEST),
        .regW(regW),
        .resetn(resetn),
        .Adat(Adat),
        .Bdat(Bdat),
        .TESTdat(TESTdat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        clear_inputs();
        @(posedge clk);
        #1 resetn = 1;
        @(posedge clk);
    end
        endtask
    task clear_inputs;

    begin
        DualWrite = 0;
        RegWrite = 0;
        Wdat = 0;
        regW = 0;
        regA = 0;
        regB = 0;
        regTEST = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();
        regA = 5;
        regB = 10;
        regTEST = 31;
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Write/Read (Reg 12)", test_num);
        reset_dut();


        @(negedge clk);
        regW = 12;
        Wdat = 32'hA5A5_B6B6;
        RegWrite = 1;
        DualWrite = 0;
        @(posedge clk);


        #1;
        RegWrite = 0;
        regA = 12;
        regB = 0;
        regTEST = 12;
        #2;
        #1;

        check_outputs(32'hA5A5_B6B6, 32'h0, 32'hA5A5_B6B6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable Check (RegWrite=0)", test_num);
        reset_dut();


        @(negedge clk);
        regW = 5;
        Wdat = 32'hFFFF_FFFF;
        RegWrite = 0;
        @(posedge clk);


        #1;
        regA = 5;
        #2;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Reads", test_num);
        reset_dut();


        @(negedge clk);
        regW = 1; Wdat = 32'h1; RegWrite = 1;
        @(posedge clk);


        @(negedge clk);
        regW = 2; Wdat = 32'h2;
        @(posedge clk);


        @(negedge clk);
        regW = 3; Wdat = 32'h3;
        @(posedge clk);


        #1;
        RegWrite = 0;
        regA = 1;
        regB = 2;
        regTEST = 3;
        #2;
        #1;

        check_outputs(32'h1, 32'h2, 32'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Dual Write Check (Reg 4 and Reg 20)", test_num);
        reset_dut();

        @(negedge clk);
        regW = 4;
        Wdat = 32'hDEAD_BEEF;
        RegWrite = 1;
        DualWrite = 1;
        @(posedge clk);

        #1;
        RegWrite = 0;
        DualWrite = 0;
        regA = 4;
        regB = 20;
        regTEST = 0;
        #2;


        #1;



        check_outputs(32'hDEAD_BEEF, 32'hDEAD_BEEF, 32'h0);
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
        input [31:0] expected_Adat;
        input [31:0] expected_Bdat;
        input [31:0] expected_TESTdat;
        begin
            if (expected_Adat === (expected_Adat ^ Adat ^ expected_Adat) &&
                expected_Bdat === (expected_Bdat ^ Bdat ^ expected_Bdat) &&
                expected_TESTdat === (expected_TESTdat ^ TESTdat ^ expected_TESTdat)) begin
                $display("PASS");
                $display("  Outputs: Adat=%h, Bdat=%h, TESTdat=%h",
                         Adat, Bdat, TESTdat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Adat=%h, Bdat=%h, TESTdat=%h",
                         expected_Adat, expected_Bdat, expected_TESTdat);
                $display("  Got:      Adat=%h, Bdat=%h, TESTdat=%h",
                         Adat, Bdat, TESTdat);
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
        $dumpvars(0,DualWrite, RegWrite, Wdat, clk, regA, regB, regTEST, regW, resetn, Adat, Bdat, TESTdat);
    end

endmodule
