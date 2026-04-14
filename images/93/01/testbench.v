`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] FromIF_Inst;
    reg [3:0] FromIF_InstNum;
    reg [3:0] FromIF_InstType;
    reg [31:0] FromIF_NewPC;
    reg clock;
    reg reset;
    wire [31:0] ToID_Inst;
    wire [3:0] ToID_InstNum;
    wire [3:0] ToID_InstType;
    wire [31:0] ToID_NewPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FromIF_Inst(FromIF_Inst),
        .FromIF_InstNum(FromIF_InstNum),
        .FromIF_InstType(FromIF_InstType),
        .FromIF_NewPC(FromIF_NewPC),
        .clock(clock),
        .reset(reset),
        .ToID_Inst(ToID_Inst),
        .ToID_InstNum(ToID_InstNum),
        .ToID_InstType(ToID_InstType),
        .ToID_NewPC(ToID_NewPC)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        FromIF_Inst = 0;
        FromIF_InstNum = 0;
        FromIF_InstType = 0;
        FromIF_NewPC = 0;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase%03d: Reset functionality", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 4'h0, 4'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase%03d: Single data capture", test_num);
        reset_dut();
        FromIF_Inst = 32'hDEADBEEF;
        FromIF_NewPC = 32'h00001000;
        FromIF_InstNum = 4'hA;
        FromIF_InstType = 4'h1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 4'hA, 4'h1, 32'h00001000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase%03d: Alternating bit patterns", test_num);
        reset_dut();
        FromIF_Inst = 32'h5555AAAA;
        FromIF_NewPC = 32'hAAAA5555;
        FromIF_InstNum = 4'h5;
        FromIF_InstType = 4'hA;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'h5555AAAA, 4'h5, 4'hA, 32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase%03d: Maximum values", test_num);
        reset_dut();
        FromIF_Inst = 32'hFFFFFFFF;
        FromIF_NewPC = 32'hFFFFFFFF;
        FromIF_InstNum = 4'hF;
        FromIF_InstType = 4'hF;
        @(posedge clock);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF, 4'hF, 4'hF, 32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase%03d: Sequential updates", test_num);
        reset_dut();

        FromIF_Inst = 32'h11111111;
        FromIF_NewPC = 32'h22222222;
        FromIF_InstNum = 4'h1;
        FromIF_InstType = 4'h2;
        @(posedge clock);

        FromIF_Inst = 32'h88888888;
        FromIF_NewPC = 32'h99999999;
        FromIF_InstNum = 4'h8;
        FromIF_InstType = 4'h9;
        @(posedge clock);
        #1;

        #1;


        check_outputs(32'h88888888, 4'h8, 4'h9, 32'h99999999);
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
        input [31:0] expected_ToID_Inst;
        input [3:0] expected_ToID_InstNum;
        input [3:0] expected_ToID_InstType;
        input [31:0] expected_ToID_NewPC;
        begin
            if (expected_ToID_Inst === (expected_ToID_Inst ^ ToID_Inst ^ expected_ToID_Inst) &&
                expected_ToID_InstNum === (expected_ToID_InstNum ^ ToID_InstNum ^ expected_ToID_InstNum) &&
                expected_ToID_InstType === (expected_ToID_InstType ^ ToID_InstType ^ expected_ToID_InstType) &&
                expected_ToID_NewPC === (expected_ToID_NewPC ^ ToID_NewPC ^ expected_ToID_NewPC)) begin
                $display("PASS");
                $display("  Outputs: ToID_Inst=%h, ToID_InstNum=%h, ToID_InstType=%h, ToID_NewPC=%h",
                         ToID_Inst, ToID_InstNum, ToID_InstType, ToID_NewPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ToID_Inst=%h, ToID_InstNum=%h, ToID_InstType=%h, ToID_NewPC=%h",
                         expected_ToID_Inst, expected_ToID_InstNum, expected_ToID_InstType, expected_ToID_NewPC);
                $display("  Got:      ToID_Inst=%h, ToID_InstNum=%h, ToID_InstType=%h, ToID_NewPC=%h",
                         ToID_Inst, ToID_InstNum, ToID_InstType, ToID_NewPC);
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
        $dumpvars(0,FromIF_Inst, FromIF_InstNum, FromIF_InstType, FromIF_NewPC, clock, reset, ToID_Inst, ToID_InstNum, ToID_InstType, ToID_NewPC);
    end

endmodule
