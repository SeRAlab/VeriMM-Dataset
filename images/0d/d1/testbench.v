`timescale 1ns/1ps

module sata_command_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] command_in;
    reg reset;
    wire [31:0] command_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_command_register dut (
        .clk(clk),
        .command_in(command_in),
        .reset(reset),
        .command_out(command_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            command_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Load");
            reset_dut();
            reset = 0;
            command_in = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Hold Mode (reset=1)");
            reset_dut();
            reset = 1;
            command_in = 32'hA5A5A5A5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load then Hold");
            reset_dut();

            reset = 0;
            command_in = 32'h12345678;
            @(posedge clk);
            #1;

            reset = 1;
            command_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: All Ones Verification");
            reset_dut();
            reset = 0;
            command_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Sequential Load");
            reset_dut();
            reset = 0;
            command_in = 32'hCAFEBABE;
            @(posedge clk);
            #1;
            command_in = 32'h00C0FFEE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00C0FFEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_command_register Testbench");
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
        input [31:0] expected_command_out;
        begin
            if (expected_command_out === (expected_command_out ^ command_out ^ expected_command_out)) begin
                $display("PASS");
                $display("  Outputs: command_out=%h",
                         command_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_out=%h",
                         expected_command_out);
                $display("  Got:      command_out=%h",
                         command_out);
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
        $dumpvars(0,clk, command_in, reset, command_out);
    end

endmodule
