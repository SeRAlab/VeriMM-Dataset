`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] IN_REG;
    wire [7:0] IN_DAT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IN_REG(IN_REG),
        .IN_DAT(IN_DAT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            IN_REG = 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            IN_REG = 8'h01;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            IN_REG = 8'h7F;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            IN_REG = 8'h55;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            IN_REG = 8'h2A;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h2A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            IN_REG = 8'h3C;
            @(posedge CLK);
            #1;
            IN_REG = 8'h00;
            @(posedge CLK);
            #2;



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
        input [7:0] expected_IN_DAT;
        begin
            if (expected_IN_DAT === (expected_IN_DAT ^ IN_DAT ^ expected_IN_DAT)) begin
                $display("PASS");
                $display("  Outputs: IN_DAT=%h",
                         IN_DAT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IN_DAT=%h",
                         expected_IN_DAT);
                $display("  Got:      IN_DAT=%h",
                         IN_DAT);
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
        $dumpvars(0,CLK, IN_REG, IN_DAT);
    end

endmodule
