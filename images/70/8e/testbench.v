`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg LOAD;
    reg RST;
    reg TRANSFER;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .RST(RST),
        .TRANSFER(TRANSFER),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            D = 0;
            LOAD = 0;
            TRANSFER = 0;
            @(posedge CLK);
            #2;
            RST = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Load 0 and Transfer");
            reset_dut();
            @(negedge CLK);
            D = 1'b0;
            LOAD = 1'b1;
            @(posedge CLK);
            #2;
            LOAD = 1'b0;
            TRANSFER = 1'b1;
            @(posedge CLK);
            #2;
            TRANSFER = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Load 0 without Transfer");
            reset_dut();
            @(negedge CLK);
            D = 1'b0;
            LOAD = 1'b1;
            TRANSFER = 1'b0;
            @(posedge CLK);
            #2;
            LOAD = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Overwrite Internal Register");
            reset_dut();
            @(negedge CLK);
            D = 1'b0;
            LOAD = 1'b1;
            @(posedge CLK);
            #2;
            D = 1'b1;
            @(posedge CLK);
            #2;
            LOAD = 1'b0;
            TRANSFER = 1'b1;
            @(posedge CLK);
            #2;
            TRANSFER = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Sequential Transfers");
            reset_dut();

            @(negedge CLK);
            D = 1'b0; LOAD = 1'b1;
            @(posedge CLK); #2;
            LOAD = 1'b0; TRANSFER = 1'b1;
            @(posedge CLK); #2;


            TRANSFER = 1'b0; D = 1'b1; LOAD = 1'b1;
            @(posedge CLK); #2;
            LOAD = 1'b0; TRANSFER = 1'b1;
            @(posedge CLK); #2;

            TRANSFER = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Simultaneous Load and Transfer");
            reset_dut();
            @(negedge CLK);
            D = 1'b0;
            LOAD = 1'b1;
            TRANSFER = 1'b1;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;
            LOAD = 1'b0;
            TRANSFER = 1'b0;
            #1;

            check_outputs(1'b0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,CLK, D, LOAD, RST, TRANSFER, Q);
    end

endmodule
