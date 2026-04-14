`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] adr;
    reg clk;
    reg [1:0] din;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .clk(clk),
        .din(din),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            adr = 2'b00;
            din = 2'b00;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            adr = 2'b00;
            din = 2'b11;
            @(negedge clk);


            adr = 2'b00;
            din = 2'b01;
            @(negedge clk);


            $display("Testcase 001: Basic Write/Read Address 0");
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            adr = 2'b01;
            din = 2'b10;
            @(negedge clk);


            adr = 2'b10;
            din = 2'b01;
            @(negedge clk);


            adr = 2'b01;
            din = 2'b00;
            @(negedge clk);

            $display("Testcase 002: Cross Address Access (Read Adr 1)");
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            adr = 2'b00; din = 2'b00; @(negedge clk);
            adr = 2'b01; din = 2'b01; @(negedge clk);
            adr = 2'b10; din = 2'b10; @(negedge clk);
            adr = 2'b11; din = 2'b11; @(negedge clk);


            adr = 2'b11; din = 2'b00; @(negedge clk);

            $display("Testcase 003: Full RAM Fill and Read Adr 3");
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            adr = 2'b10; din = 2'b01; @(negedge clk);
            adr = 2'b10; din = 2'b10; @(negedge clk);
            adr = 2'b10; din = 2'b11; @(negedge clk);

            $display("Testcase 004: Continuous Overwrite Adr 2");
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,adr, clk, din, q);
    end

endmodule
