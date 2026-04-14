`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk10;
    reg enb;
    reg [9:0] entradas;
    reg rst;
    wire salida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk10(clk10),
        .enb(enb),
        .entradas(entradas),
        .rst(rst),
        .salida(salida)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enb = 0;
            clk10 = 0;
            entradas = 10'b0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: MSB (Bit 9) check...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b1000000000;
            enb = 1;
            clk10 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
            clk10 = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: LSB (Bit 0) check...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b0000000001;
            enb = 1;
            clk10 = 1;
            @(posedge clk);
            clk10 = 0;
            repeat(9) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Middle bit (Bit 5) check...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b0000100000;
            enb = 1;
            clk10 = 1;
            @(posedge clk);
            clk10 = 0;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable signal check (enb=0)...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b1111111111;
            enb = 0;
            clk10 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset during operation check...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b1111111111;
            enb = 1;
            clk10 = 1;
            @(posedge clk);
            rst = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Zero bit serialization check...");
            reset_dut();
            test_num = test_num + 1;
            entradas = 10'b1111011111;
            enb = 1;
            clk10 = 1;
            @(posedge clk);
            clk10 = 0;
            repeat(4) @(posedge clk);
            #2;
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
        input expected_salida;
        begin
            if (expected_salida === (expected_salida ^ salida ^ expected_salida)) begin
                $display("PASS");
                $display("  Outputs: salida=%b",
                         salida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: salida=%b",
                         expected_salida);
                $display("  Got:      salida=%b",
                         salida);
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
        $dumpvars(0,clk, clk10, enb, entradas, rst, salida);
    end

endmodule
