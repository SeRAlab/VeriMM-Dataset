`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DR;
    reg RESET;
    reg RegW;
    reg [31:0] Reg_in;
    reg [3:0] SR1;
    reg [3:0] SR2;
    wire [31:0] ReadReg1;
    wire [31:0] ReadReg2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DR(DR),
        .RESET(RESET),
        .RegW(RegW),
        .Reg_in(Reg_in),
        .SR1(SR1),
        .SR2(SR2),
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            RegW = 0;
            DR = 0;
            SR1 = 0;
            SR2 = 0;
            Reg_in = 0;
            @(posedge CLK);
            #2 RESET = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            SR1 = 4'hA;
            SR2 = 4'hF;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();
            @(posedge CLK);
            RegW = 1;
            DR = 4'h1;
            Reg_in = 32'hDEADBEEF;
            @(posedge CLK);
            RegW = 0;
            SR1 = 4'h1;
            SR2 = 4'h1;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();
            @(posedge CLK);
            RegW = 0;
            DR = 4'h5;
            Reg_in = 32'hCAFEBABE;
            @(posedge CLK);
            SR1 = 4'h5;
            SR2 = 4'h0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Dual Port Read", test_num);
            reset_dut();

            @(posedge CLK);
            RegW = 1; DR = 4'h2; Reg_in = 32'h11112222;
            @(posedge CLK);

            DR = 4'h3; Reg_in = 32'h33334444;
            @(posedge CLK);
            RegW = 0;
            SR1 = 4'h2;
            SR2 = 4'h3;
            #1;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwrite and Boundary", test_num);
            reset_dut();
            @(posedge CLK);
            RegW = 1; DR = 4'hF; Reg_in = 32'hAAAAAAAA;
            @(posedge CLK);
            DR = 4'hF; Reg_in = 32'h55555555;
            @(posedge CLK);
            RegW = 0;
            SR1 = 4'hF;
            SR2 = 4'h0;
            #1;
            #1;

            check_outputs(32'h55555555, 32'h0);
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
        input [31:0] expected_ReadReg1;
        input [31:0] expected_ReadReg2;
        begin
            if (expected_ReadReg1 === (expected_ReadReg1 ^ ReadReg1 ^ expected_ReadReg1) &&
                expected_ReadReg2 === (expected_ReadReg2 ^ ReadReg2 ^ expected_ReadReg2)) begin
                $display("PASS");
                $display("  Outputs: ReadReg1=%h, ReadReg2=%h",
                         ReadReg1, ReadReg2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadReg1=%h, ReadReg2=%h",
                         expected_ReadReg1, expected_ReadReg2);
                $display("  Got:      ReadReg1=%h, ReadReg2=%h",
                         ReadReg1, ReadReg2);
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
        $dumpvars(0,CLK, DR, RESET, RegW, Reg_in, SR1, SR2, ReadReg1, ReadReg2);
    end

endmodule
