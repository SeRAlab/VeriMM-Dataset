`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Cambio;
    reg clk;
    reg got_data;
    reg rst;
    wire [1:0] Cuenta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cambio(Cambio),
        .clk(clk),
        .got_data(got_data),
        .rst(rst),
        .Cuenta(Cuenta)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Cambio = 8'h00;
            got_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verifying reset state...");
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Incrementing to max and wrapping around...");
            reset_dut();
            Cambio = 8'h7A;
            got_data = 1;


            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Decrementing from zero to wrap to max...");
            reset_dut();
            Cambio = 8'h69;
            got_data = 1;


            @(posedge clk);

            #1 #1;
 check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verifying got_data=0 inhibits counting...");
            reset_dut();
            Cambio = 8'h7A;
            got_data = 0;

            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verifying invalid Cambio value inhibits counting...");
            reset_dut();
            Cambio = 8'hFF;
            got_data = 1;

            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(2'b00);
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
        input [1:0] expected_Cuenta;
        begin
            if (expected_Cuenta === (expected_Cuenta ^ Cuenta ^ expected_Cuenta)) begin
                $display("PASS");
                $display("  Outputs: Cuenta=%h",
                         Cuenta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cuenta=%h",
                         expected_Cuenta);
                $display("  Got:      Cuenta=%h",
                         Cuenta);
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
        $dumpvars(0,Cambio, clk, got_data, rst, Cuenta);
    end

endmodule
