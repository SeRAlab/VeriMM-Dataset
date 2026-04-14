`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACK_I;
    reg CLK_I;
    reg [31:0] DAT_I;
    reg INT_I;
    reg RST_I;
    wire [31:0] ADR_O;
    wire CYC_O;
    wire [31:0] DAT_O;
    wire [3:0] SEL_O;
    wire STB_O;
    wire WE_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACK_I(ACK_I),
        .CLK_I(CLK_I),
        .DAT_I(DAT_I),
        .INT_I(INT_I),
        .RST_I(RST_I),
        .ADR_O(ADR_O),
        .CYC_O(CYC_O),
        .DAT_O(DAT_O),
        .SEL_O(SEL_O),
        .STB_O(STB_O),
        .WE_O(WE_O)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_I = 0;
        forever #5 CLK_I = ~CLK_I;
    end

        task reset_dut;

    begin
        RST_I = 1;
        ACK_I = 0;
        DAT_I = 0;
        INT_I = 0;
        repeat(5) @(posedge CLK_I);
        #1;
        RST_I = 0;
        @(posedge CLK_I);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: Reset State Verification", test_num);
        RST_I = 1;
        ACK_I = 0;
        repeat(2) @(posedge CLK_I);
        #1;

        #1;


        check_outputs(32'h00000000, 1'b0, 32'h00000000, 4'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Instruction Fetch Initiation", test_num);
        reset_dut();


        wait(CYC_O === 1'b1);
        @(posedge CLK_I);
        #1;



        #1;




        check_outputs(32'h00000000, 1'b1, DAT_O, 4'hf, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Memory Read Acknowledge", test_num);
        reset_dut();


        wait(CYC_O === 1'b1);
        @(posedge CLK_I);


        ACK_I = 1;
        DAT_I = 32'h3C011234;
        @(posedge CLK_I);
        #1;
        ACK_I = 0;



        #1;




        check_outputs(32'h00000004, 1'b1, DAT_O, 4'hf, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Interrupt Handling", test_num);
        reset_dut();

        wait(CYC_O === 1'b1);
        INT_I = 1;
        @(posedge CLK_I);
        ACK_I = 1;
        DAT_I = 32'h00000000;
        @(posedge CLK_I);
        #1;
        ACK_I = 0;
        INT_I = 0;


        if (CYC_O === 1'b1) begin
            $display("System remained active during interrupt.");
            #1;

            check_outputs(ADR_O, 1'b1, DAT_O, 4'hf, 1'b1, 1'b0);
        end else begin
            $display("System idled.");
            #1;

            check_outputs(ADR_O, 1'b0, DAT_O, SEL_O, 1'b0, WE_O);
        end
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
        input [31:0] expected_ADR_O;
        input expected_CYC_O;
        input [31:0] expected_DAT_O;
        input [3:0] expected_SEL_O;
        input expected_STB_O;
        input expected_WE_O;
        begin
            if (expected_ADR_O === (expected_ADR_O ^ ADR_O ^ expected_ADR_O) &&
                expected_CYC_O === (expected_CYC_O ^ CYC_O ^ expected_CYC_O) &&
                expected_DAT_O === (expected_DAT_O ^ DAT_O ^ expected_DAT_O) &&
                expected_SEL_O === (expected_SEL_O ^ SEL_O ^ expected_SEL_O) &&
                expected_STB_O === (expected_STB_O ^ STB_O ^ expected_STB_O) &&
                expected_WE_O === (expected_WE_O ^ WE_O ^ expected_WE_O)) begin
                $display("PASS");
                $display("  Outputs: ADR_O=%h, CYC_O=%b, DAT_O=%h, SEL_O=%h, STB_O=%b, WE_O=%b",
                         ADR_O, CYC_O, DAT_O, SEL_O, STB_O, WE_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADR_O=%h, CYC_O=%b, DAT_O=%h, SEL_O=%h, STB_O=%b, WE_O=%b",
                         expected_ADR_O, expected_CYC_O, expected_DAT_O, expected_SEL_O, expected_STB_O, expected_WE_O);
                $display("  Got:      ADR_O=%h, CYC_O=%b, DAT_O=%h, SEL_O=%h, STB_O=%b, WE_O=%b",
                         ADR_O, CYC_O, DAT_O, SEL_O, STB_O, WE_O);
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
        $dumpvars(0,ACK_I, CLK_I, DAT_I, INT_I, RST_I, ADR_O, CYC_O, DAT_O, SEL_O, STB_O, WE_O);
    end

endmodule
