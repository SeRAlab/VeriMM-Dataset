`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [63:0] IAlu;
    reg [63:0] IDataMemory;
    reg [4:0] IInstruction;
    reg [1:0] IWB;
    wire [63:0] OAlu;
    wire [63:0] ODataMemory;
    wire [4:0] OInstruction;
    wire OWB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .IAlu(IAlu),
        .IDataMemory(IDataMemory),
        .IInstruction(IInstruction),
        .IWB(IWB),
        .OAlu(OAlu),
        .ODataMemory(ODataMemory),
        .OInstruction(OInstruction),
        .OWB(OWB)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            IAlu = 64'h0;
            IDataMemory = 64'h0;
            IInstruction = 5'h0;
            IWB = 2'b00;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic functional check", test_num);
            reset_dut();

            IAlu = 64'h1122334455667788;
            IDataMemory = 64'h99AABBCCDDEEFFFF;
            IInstruction = 5'b11011;
            IWB = 2'b01;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(64'h1122334455667788, 64'h99AABBCCDDEEFFFF, 5'b11011, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns (AAAA/5555)", test_num);
            reset_dut();

            IAlu = 64'hAAAAAAAAAAAAAAAA;
            IDataMemory = 64'h5555555555555555;
            IInstruction = 5'b01010;
            IWB = 2'b00;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555, 5'b01010, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros check", test_num);
            reset_dut();

            IAlu = 64'h0;
            IDataMemory = 64'h0;
            IInstruction = 5'h0;
            IWB = 2'b00;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(64'h0, 64'h0, 5'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values check (All Fs)", test_num);
            reset_dut();

            IAlu = 64'hFFFFFFFFFFFFFFFF;
            IDataMemory = 64'hFFFFFFFFFFFFFFFF;
            IInstruction = 5'h1F;
            IWB = 2'b11;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF, 5'h1F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify latching behavior with rapid changes", test_num);
            reset_dut();


            IAlu = 64'hCAFE_BABE_DEAD_BEEF;
            IDataMemory = 64'h0000_1111_2222_3333;
            IInstruction = 5'h0A;
            IWB = 2'b01;

            @(posedge Clk);
            #1;

            IAlu = 64'h0;
            IDataMemory = 64'h0;
            IInstruction = 5'h0;
            IWB = 2'b00;

            #1;
            #1;

            check_outputs(64'hCAFE_BABE_DEAD_BEEF, 64'h0000_1111_2222_3333, 5'h0A, 1'b1);


            @(posedge Clk);
            #2;
            #1;

            check_outputs(64'h0, 64'h0, 5'h0, 1'b0);
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
        input [63:0] expected_OAlu;
        input [63:0] expected_ODataMemory;
        input [4:0] expected_OInstruction;
        input expected_OWB;
        begin
            if (expected_OAlu === (expected_OAlu ^ OAlu ^ expected_OAlu) &&
                expected_ODataMemory === (expected_ODataMemory ^ ODataMemory ^ expected_ODataMemory) &&
                expected_OInstruction === (expected_OInstruction ^ OInstruction ^ expected_OInstruction) &&
                expected_OWB === (expected_OWB ^ OWB ^ expected_OWB)) begin
                $display("PASS");
                $display("  Outputs: OAlu=%h, ODataMemory=%h, OInstruction=%h, OWB=%b",
                         OAlu, ODataMemory, OInstruction, OWB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OAlu=%h, ODataMemory=%h, OInstruction=%h, OWB=%b",
                         expected_OAlu, expected_ODataMemory, expected_OInstruction, expected_OWB);
                $display("  Got:      OAlu=%h, ODataMemory=%h, OInstruction=%h, OWB=%b",
                         OAlu, ODataMemory, OInstruction, OWB);
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
        $dumpvars(0,Clk, IAlu, IDataMemory, IInstruction, IWB, OAlu, ODataMemory, OInstruction, OWB);
    end

endmodule
