`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DImag;
    reg [31:0] DReal;
    reg ED;
    reg RST;
    reg START;
    wire [31:0] DOImag;
    wire [31:0] DOReal;
    wire RDY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DImag(DImag),
        .DReal(DReal),
        .ED(ED),
        .RST(RST),
        .START(START),
        .DOImag(DOImag),
        .DOReal(DOReal),
        .RDY(RDY)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        ED = 0;
        START = 0;
        DReal = 0;
        DImag = 0;
        repeat(5) @(posedge CLK);
        #1 RST = 0;
        repeat(2) @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();



        #1;




        check_outputs(32'h0, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("\nTestcase %0d: Fill RAM (32 locations) and Check RDY", test_num);
        reset_dut();

        @(posedge CLK);
        START = 1;
        @(posedge CLK);
        START = 0;
        ED = 1;

        for (i = 0; i < 32; i = i + 1) begin
            DReal = i + 32'hA0;
            DImag = i + 32'hB0;
            @(posedge CLK);
        end

        ED = 0;



        #1;




        check_outputs(32'hB0, 32'hA0, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("\nTestcase %0d: Sequential Write and Address Counter Check", test_num);
        reset_dut();

        @(posedge CLK);
        START = 1;
        @(posedge CLK);
        START = 0;
        ED = 1;


        for (i = 0; i < 16; i = i + 1) begin
            DReal = i * 2;
            DImag = i * 3;
            @(posedge CLK);
        end

        ED = 0;




        #1;





        check_outputs(32'h0, 32'h0, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("\nTestcase %0d: Buffer Wrap-around and RDY Toggling", test_num);
        reset_dut();

        @(posedge CLK);
        START = 1;
        ED = 1;


        for (i = 0; i < 64; i = i + 1) begin
            DReal = i;
            DImag = ~i;
            @(posedge CLK);
        end

        ED = 0;
        START = 0;




        #1;





        check_outputs(~32'd32, 32'd32, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Interrupted Write (ED Control)", test_num);
        reset_dut();

        @(posedge CLK);
        START = 1;
        @(posedge CLK);
        START = 0;


        ED = 1;
        DReal = 32'hDEAD;
        DImag = 32'hBEEF;
        @(posedge CLK);


        ED = 0;
        DReal = 32'hFFFF;
        DImag = 32'hFFFF;
        repeat(5) @(posedge CLK);


        ED = 1;
        DReal = 32'h1234;
        DImag = 32'h5678;
        @(posedge CLK);
        ED = 0;



        #1;




        check_outputs(32'hBEEF, 32'hDEAD, 1'b0);
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
        input [31:0] expected_DOImag;
        input [31:0] expected_DOReal;
        input expected_RDY;
        begin
            if (expected_DOImag === (expected_DOImag ^ DOImag ^ expected_DOImag) &&
                expected_DOReal === (expected_DOReal ^ DOReal ^ expected_DOReal) &&
                expected_RDY === (expected_RDY ^ RDY ^ expected_RDY)) begin
                $display("PASS");
                $display("  Outputs: DOImag=%h, DOReal=%h, RDY=%b",
                         DOImag, DOReal, RDY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOImag=%h, DOReal=%h, RDY=%b",
                         expected_DOImag, expected_DOReal, expected_RDY);
                $display("  Got:      DOImag=%h, DOReal=%h, RDY=%b",
                         DOImag, DOReal, RDY);
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
        $dumpvars(0,CLK, DImag, DReal, ED, RST, START, DOImag, DOReal, RDY);
    end

endmodule
