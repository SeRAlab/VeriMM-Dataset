`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EXMEMRead;
    reg [4:0] EXMEMRt;
    reg IDEXMemRead;
    reg [4:0] IDEXRd;
    reg IDEXRegWrite;
    reg [4:0] IDEXRt;
    reg [4:0] IFIDRs;
    reg [4:0] IFIDRt;
    reg clk;
    reg [5:0] opcode;
    wire IFIDWrite;
    wire PCWrite;
    wire ctrlSetZero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEMRead(EXMEMRead),
        .EXMEMRt(EXMEMRt),
        .IDEXMemRead(IDEXMemRead),
        .IDEXRd(IDEXRd),
        .IDEXRegWrite(IDEXRegWrite),
        .IDEXRt(IDEXRt),
        .IFIDRs(IFIDRs),
        .IFIDRt(IFIDRt),
        .clk(clk),
        .opcode(opcode),
        .IFIDWrite(IFIDWrite),
        .PCWrite(PCWrite),
        .ctrlSetZero(ctrlSetZero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            EXMEMRead = 0;
            EXMEMRt = 0;
            IDEXMemRead = 0;
            IDEXRd = 0;
            IDEXRegWrite = 0;
            IDEXRt = 0;
            IFIDRs = 0;
            IFIDRt = 0;
            opcode = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            IFIDRs = 5'd1;
            IFIDRt = 5'd2;
            IDEXRt = 5'd3;
            IDEXMemRead = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: No Hazard", test_num);
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            IDEXMemRead = 1;
            IDEXRt = 5'd10;
            IFIDRs = 5'd10;
            IFIDRt = 5'd11;
            @(posedge clk);
            #1;
            $display("Test %0d: Load-Use Hazard (Rs)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            IDEXMemRead = 1;
            IDEXRt = 5'd10;
            IFIDRs = 5'd5;
            IFIDRt = 5'd10;
            @(posedge clk);
            #1;
            $display("Test %0d: Load-Use Hazard (Rt)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            IDEXMemRead = 1;
            IDEXRt = 5'd0;
            IFIDRs = 5'd0;
            IFIDRt = 5'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Register 0 Dependency (No Stall)", test_num);
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            opcode = 6'h04;
            IFIDRs = 5'd8;
            IDEXRegWrite = 1;
            IDEXRd = 5'd8;
            @(posedge clk);
            #1;
            $display("Test %0d: Branch Hazard (ID/EX Dependency)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            opcode = 6'h04;
            IFIDRt = 5'd9;
            EXMEMRead = 1;
            EXMEMRt = 5'd9;
            @(posedge clk);
            #1;
            $display("Test %0d: Branch Hazard (EX/MEM Mem Dependency)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            IDEXMemRead = 0;
            IDEXRegWrite = 1;
            IDEXRt = 5'd15;
            IFIDRs = 5'd15;
            opcode = 6'h00;
            @(posedge clk);
            #1;
            $display("Test %0d: ALU-ALU dependency (Forwarding, No Stall)", test_num);
            #1;

            check_outputs(1, 1, 0);
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
        input expected_IFIDWrite;
        input expected_PCWrite;
        input expected_ctrlSetZero;
        begin
            if (expected_IFIDWrite === (expected_IFIDWrite ^ IFIDWrite ^ expected_IFIDWrite) &&
                expected_PCWrite === (expected_PCWrite ^ PCWrite ^ expected_PCWrite) &&
                expected_ctrlSetZero === (expected_ctrlSetZero ^ ctrlSetZero ^ expected_ctrlSetZero)) begin
                $display("PASS");
                $display("  Outputs: IFIDWrite=%b, PCWrite=%b, ctrlSetZero=%b",
                         IFIDWrite, PCWrite, ctrlSetZero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IFIDWrite=%b, PCWrite=%b, ctrlSetZero=%b",
                         expected_IFIDWrite, expected_PCWrite, expected_ctrlSetZero);
                $display("  Got:      IFIDWrite=%b, PCWrite=%b, ctrlSetZero=%b",
                         IFIDWrite, PCWrite, ctrlSetZero);
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
        $dumpvars(0,EXMEMRead, EXMEMRt, IDEXMemRead, IDEXRd, IDEXRegWrite, IDEXRt, IFIDRs, IFIDRt, clk, opcode, IFIDWrite, PCWrite, ctrlSetZero);
    end

endmodule
