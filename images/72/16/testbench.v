`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUOut;
    reg [31:0] Memout;
    reg [4:0] RegRD;
    reg [1:0] WB;
    reg clock;
    wire [31:0] ALUreg;
    wire [31:0] Memreg;
    wire [4:0] RegRDreg;
    wire [1:0] WBreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOut(ALUOut),
        .Memout(Memout),
        .RegRD(RegRD),
        .WB(WB),
        .clock(clock),
        .ALUreg(ALUreg),
        .Memreg(Memreg),
        .RegRDreg(RegRDreg),
        .WBreg(WBreg)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ALUOut = 32'h0;
            Memout = 32'h0;
            RegRD  = 5'h0;
            WB     = 2'b00;


            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Data Transfer", test_num);
            reset_dut();


            ALUOut = 32'h12345678;
            Memout = 32'hABCDEFFF;
            RegRD  = 5'd10;
            WB     = 2'b10;


            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h12345678, 32'hABCDEFFF, 5'd10, 2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Pattern Toggle", test_num);
            reset_dut();


            ALUOut = 32'h55555555;
            Memout = 32'hAAAAAAAA;
            RegRD  = 5'd31;
            WB     = 2'b01;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h55555555, 32'hAAAAAAAA, 5'd31, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Max)", test_num);
            reset_dut();


            ALUOut = 32'hFFFFFFFF;
            Memout = 32'hFFFFFFFF;
            RegRD  = 5'b11111;
            WB     = 2'b11;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 5'b11111, 2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Min/Zero)", test_num);
            reset_dut();


            ALUOut = 32'h00000000;
            Memout = 32'h00000000;
            RegRD  = 5'b00000;
            WB     = 2'b00;

            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h00000000, 32'h00000000, 5'b00000, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipelined Sequence Check", test_num);
            reset_dut();


            ALUOut = 32'hCAFEF00D;
            Memout = 32'hDEADC0DE;
            RegRD  = 5'd5;
            WB     = 2'b11;

            @(posedge clock);
            #1;


            ALUOut = 32'h0;
            Memout = 32'h0;
            RegRD  = 5'd0;
            WB     = 2'b00;

            #1;
            #1;

            check_outputs(32'hCAFEF00D, 32'hDEADC0DE, 5'd5, 2'b11);
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
        input [31:0] expected_ALUreg;
        input [31:0] expected_Memreg;
        input [4:0] expected_RegRDreg;
        input [1:0] expected_WBreg;
        begin
            if (expected_ALUreg === (expected_ALUreg ^ ALUreg ^ expected_ALUreg) &&
                expected_Memreg === (expected_Memreg ^ Memreg ^ expected_Memreg) &&
                expected_RegRDreg === (expected_RegRDreg ^ RegRDreg ^ expected_RegRDreg) &&
                expected_WBreg === (expected_WBreg ^ WBreg ^ expected_WBreg)) begin
                $display("PASS");
                $display("  Outputs: ALUreg=%h, Memreg=%h, RegRDreg=%h, WBreg=%h",
                         ALUreg, Memreg, RegRDreg, WBreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUreg=%h, Memreg=%h, RegRDreg=%h, WBreg=%h",
                         expected_ALUreg, expected_Memreg, expected_RegRDreg, expected_WBreg);
                $display("  Got:      ALUreg=%h, Memreg=%h, RegRDreg=%h, WBreg=%h",
                         ALUreg, Memreg, RegRDreg, WBreg);
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
        $dumpvars(0,ALUOut, Memout, RegRD, WB, clock, ALUreg, Memreg, RegRDreg, WBreg);
    end

endmodule
