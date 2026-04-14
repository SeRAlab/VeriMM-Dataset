`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clock;
    wire [31:0] instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .instruction(instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 32'h0;


            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reading Address 0x00000000", test_num);
            reset_dut();
            address = 32'h0;
            #10;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reading Address 0x00000001", test_num);
            reset_dut();
            address = 32'h1;
            #10;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reading Address 0x00000002", test_num);
            reset_dut();
            address = 32'h2;
            #10;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reading Address 0x0000000F (15)", test_num);
            reset_dut();
            address = 32'hF;
            #10;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Jump Access to Address 0x00000020 (32)", test_num);
            reset_dut();
            address = 32'h20;
            #10;
            #1;

            check_outputs(32'h00000020);
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
        input [31:0] expected_instruction;
        begin
            if (expected_instruction === (expected_instruction ^ instruction ^ expected_instruction)) begin
                $display("PASS");
                $display("  Outputs: instruction=%h",
                         instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction=%h",
                         expected_instruction);
                $display("  Got:      instruction=%h",
                         instruction);
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
        $dumpvars(0,address, clock, instruction);
    end

endmodule
