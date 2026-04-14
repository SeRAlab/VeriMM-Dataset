`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ADD_I;
    reg clk;
    reg reset;
    reg [7:0] user_key;
    wire [31:0] DAT_O;
    wire IRQ_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD_I(ADD_I),
        .clk(clk),
        .reset(reset),
        .user_key(user_key),
        .DAT_O(DAT_O),
        .IRQ_O(IRQ_O)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        user_key = 8'h00;
        ADD_I = 32'h0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        ADD_I = 32'h0000_7f40;
        user_key = 8'h00;
        #2;

        #1;


        check_outputs(32'h0000_00FF, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        user_key = 8'hAA;
        @(posedge clk);
        #2;


        user_key = 8'h00;
        ADD_I = 32'h0000_7f40;
        #2;


        #1;



        check_outputs(32'h0000_0055, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        user_key = 8'hF0;
        @(posedge clk);
        #2;

        ADD_I = 32'hFFFF_FFFF;
        #2;


        #1;



        check_outputs(32'h0000_0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        user_key = 8'hCC;
        @(posedge clk);
        #2;

        user_key = 8'h33;
        @(posedge clk);
        #2;

        ADD_I = 32'h0000_7f40;
        #2;
        #1;

        check_outputs(32'h0000_00CC, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        reset = 1;
        user_key = 8'h55;
        #2;

        #1;


        check_outputs(32'h0, 1'b0);
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
        input [31:0] expected_DAT_O;
        input expected_IRQ_O;
        begin
            if (expected_DAT_O === (expected_DAT_O ^ DAT_O ^ expected_DAT_O) &&
                expected_IRQ_O === (expected_IRQ_O ^ IRQ_O ^ expected_IRQ_O)) begin
                $display("PASS");
                $display("  Outputs: DAT_O=%h, IRQ_O=%b",
                         DAT_O, IRQ_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DAT_O=%h, IRQ_O=%b",
                         expected_DAT_O, expected_IRQ_O);
                $display("  Got:      DAT_O=%h, IRQ_O=%b",
                         DAT_O, IRQ_O);
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
        $dumpvars(0,ADD_I, clk, reset, user_key, DAT_O, IRQ_O);
    end

endmodule
