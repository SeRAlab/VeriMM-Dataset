`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC_next;
    reg clk;
    reg reset;
    wire [31:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_next(PC_next),
        .clk(clk),
        .reset(reset),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        PC_next = 32'h0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify Reset Value", test_num);
        reset_dut();

        #1;


        check_outputs(32'h80000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple PC Update", test_num);
        reset_dut();
        @(negedge clk);
        PC_next = 32'h80000004;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h80000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Jump to Specific Address", test_num);
        reset_dut();
        @(negedge clk);
        PC_next = 32'h00001234;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Load Large Address", test_num);
        reset_dut();
        @(negedge clk);
        PC_next = 32'hFFFFFFFC;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multiple Cycles Update", test_num);
        reset_dut();


        @(negedge clk);
        PC_next = 32'h80000004;
        @(posedge clk);


        @(negedge clk);
        PC_next = 32'h80000008;
        @(posedge clk);


        @(negedge clk);
        PC_next = 32'h8000000C;
        @(posedge clk);

        #1;
        #1;

        check_outputs(32'h8000000C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset Priority over PC_next", test_num);
        reset_dut();


        @(negedge clk);
        PC_next = 32'h11223344;

        reset = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h80000000);
        reset = 0;
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
        input [31:0] expected_PC;
        begin
            if (expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: PC=%h",
                         PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC=%h",
                         expected_PC);
                $display("  Got:      PC=%h",
                         PC);
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
        $dumpvars(0,PC_next, clk, reset, PC);
    end

endmodule
