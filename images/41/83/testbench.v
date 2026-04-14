`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [31:0] Data_in;
    reg Reset;
    reg Wr;
    wire [31:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Data_in(Data_in),
        .Reset(Reset),
        .Wr(Wr),
        .Data_out(Data_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        Reset = 1;
        Wr = 0;
        Data_in = 32'h0;
        #15;
        Reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Post-Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Basic Synchronous Write", test_num);
        reset_dut();
        Data_in = 32'hABCDE123;
        Wr = 1;
        @(posedge Clk);
        #1;
        #1;

        check_outputs(32'hABCDE123);
        Wr = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Write Enable (Wr=0) Check", test_num);
        reset_dut();


        Data_in = 32'h11112222;
        Wr = 1;
        @(posedge Clk);
        #1;


        Wr = 0;
        Data_in = 32'hFFFFFFFF;
        @(posedge Clk);
        #1;


        #1;



        check_outputs(32'h11112222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Asynchronous Reset Priority", test_num);
        reset_dut();


        Data_in = 32'h5555AAAA;
        Wr = 1;
        @(posedge Clk);
        #1;


        #3;
        Reset = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
        Reset = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Boundary Value (All 1s)", test_num);
        reset_dut();

        Data_in = 32'hFFFFFFFF;
        Wr = 1;
        @(posedge Clk);
        #1;

        #1;


        check_outputs(32'hFFFFFFFF);
        Wr = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Data Stability Check", test_num);
        reset_dut();

        Data_in = 32'hCAFEBABE;
        Wr = 1;
        @(posedge Clk);
        #1;
        Wr = 0;


        repeat (5) @(posedge Clk);
        #1;

        #1;


        check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_Data_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
        $dumpvars(0,Clk, Data_in, Reset, Wr, Data_out);
    end

endmodule
