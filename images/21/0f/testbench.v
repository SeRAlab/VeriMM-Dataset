`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg reset;
    wire [7:0] instruction_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        instruction_in = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Single LOAD instruction (0x48)");
        reset_dut();
        instruction_in = 8'h48;
        @(posedge clk);
        #1;
        instruction_in = 8'h00;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h48);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Single ADD instruction (0x8A)");
        reset_dut();
        instruction_in = 8'h8A;
        @(posedge clk);
        #1;
        instruction_in = 8'h00;
        repeat (3) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h8A);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Sequential Pipeline execution");
        reset_dut();


        instruction_in = 8'h41; @(posedge clk); #1;
        instruction_in = 8'h82; @(posedge clk); #1;
        instruction_in = 8'h43; @(posedge clk); #1;
        instruction_in = 8'h00;




        repeat (2) @(posedge clk);
        #1;
        $display("Checking last instruction in stream (0x43)...");
        repeat (1) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h43);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Reset mid-execution");
        reset_dut();
        instruction_in = 8'hFF;
        @(posedge clk);
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat (3) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
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
        input [7:0] expected_instruction_out;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h",
                         instruction_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h",
                         expected_instruction_out);
                $display("  Got:      instruction_out=%h",
                         instruction_out);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out);
    end

endmodule
