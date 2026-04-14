`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bus;
    reg clk;
    reg lda;
    wire [15:0] A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus(bus),
        .clk(clk),
        .lda(lda),
        .A(A)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bus <= 16'h0;
            lda <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bus <= 16'hAAAA;
            lda <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bus <= 16'h5555;
            lda <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            bus <= 16'hBEEF;
            lda <= 1'b1;
            @(posedge clk);
            #1;

            bus <= 16'hDEAD;
            lda <= 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bus <= 16'h0000;
            lda <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bus <= 16'hFFFF;
            lda <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bus <= 16'h1111;
            lda <= 1'b1;
            @(posedge clk);
            #1;
            bus <= 16'h2222;
            @(posedge clk);
            #1;
            bus <= 16'h3333;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h3333);
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
        input [15:0] expected_A;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%h",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h",
                         expected_A);
                $display("  Got:      A=%h",
                         A);
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
        $dumpvars(0,bus, clk, lda, A);
    end

endmodule
