`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DIN;
    reg [3:0] DR;
    reg LOCK;
    reg [3:0] SR1;
    reg [3:0] SR2;
    reg WE;
    wire [31:0] SR1OUT;
    wire [31:0] SR2OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIN(DIN),
        .DR(DR),
        .LOCK(LOCK),
        .SR1(SR1),
        .SR2(SR2),
        .WE(WE),
        .SR1OUT(SR1OUT),
        .SR2OUT(SR2OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        DIN = 32'b0;
        DR = 4'b0;
        LOCK = 1'b0;
        SR1 = 4'b0;
        SR2 = 4'b0;
        WE = 1'b0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %0d: Basic Write and Read", test_num);

        @(negedge CLK);
        WE = 1; LOCK = 1; DR = 4'd1; DIN = 32'h12345678;
        @(posedge CLK);
        #2;
        WE = 0; LOCK = 0; SR1 = 4'd1; SR2 = 4'd0;
        #1;
        #1;

        check_outputs(32'h12345678, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %0d: LOCK signal verification", test_num);


        @(negedge CLK);
        WE = 1; LOCK = 1; DR = 4'd2; DIN = 32'hAAAA_AAAA;
        @(posedge CLK);


        @(negedge CLK);
        WE = 1; LOCK = 0; DR = 4'd2; DIN = 32'hBBBB_BBBB;
        @(posedge CLK);

        #2;
        SR1 = 4'd2;
        SR2 = 4'd0;
        #1;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %0d: WE signal verification", test_num);


        @(negedge CLK);
        WE = 1; LOCK = 1; DR = 4'd3; DIN = 32'hCCCC_CCCC;
        @(posedge CLK);


        @(negedge CLK);
        WE = 0; LOCK = 1; DR = 4'd3; DIN = 32'hDDDD_DDDD;
        @(posedge CLK);

        #2;
        SR1 = 4'd3;
        SR2 = 4'd0;
        #1;
        #1;

        check_outputs(32'hCCCC_CCCC, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %0d: Simultaneous dual read", test_num);


        @(negedge CLK);
        WE = 1; LOCK = 1; DR = 4'd10; DIN = 32'h1111_2222;
        @(posedge CLK);


        @(negedge CLK);
        WE = 1; LOCK = 1; DR = 4'd11; DIN = 32'h3333_4444;
        @(posedge CLK);

        #2;
        SR1 = 4'd10;
        SR2 = 4'd11;
        #1;
        #1;

        check_outputs(32'h1111_2222, 32'h3333_4444);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %0d: Read-During-Write bypass logic", test_num);

        @(negedge CLK);

        WE = 1; LOCK = 1; DR = 4'd5; DIN = 32'hFACE_FEED;
        SR1 = 4'd5;
        SR2 = 4'd5;


        @(posedge CLK);
        #2;
        #1;

        check_outputs(32'hFACE_FEED, 32'hFACE_FEED);
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
        input [31:0] expected_SR1OUT;
        input [31:0] expected_SR2OUT;
        begin
            if (expected_SR1OUT === (expected_SR1OUT ^ SR1OUT ^ expected_SR1OUT) &&
                expected_SR2OUT === (expected_SR2OUT ^ SR2OUT ^ expected_SR2OUT)) begin
                $display("PASS");
                $display("  Outputs: SR1OUT=%h, SR2OUT=%h",
                         SR1OUT, SR2OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SR1OUT=%h, SR2OUT=%h",
                         expected_SR1OUT, expected_SR2OUT);
                $display("  Got:      SR1OUT=%h, SR2OUT=%h",
                         SR1OUT, SR2OUT);
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
        $dumpvars(0,CLK, DIN, DR, LOCK, SR1, SR2, WE, SR1OUT, SR2OUT);
    end

endmodule
