`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg RE;
    reg WE;
    reg clk;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RE = 0;
            WE = 0;
            data_in = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            WE = 1;
            data_in = 4'hA;
            @(posedge clk);
            #1;

            WE = 0;
            RE = 1;
            @(posedge clk);
            #1;
            $display("Testcase 001: Write and Read 4'hA");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            WE = 1;
            data_in = 4'hF;
            @(posedge clk);
            #1;

            WE = 0;
            RE = 1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Write and Read 4'hF");
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            WE = 1;
            data_in = 4'hC;
            @(posedge clk);
            #1;

            WE = 0;
            data_in = 4'h5;
            @(posedge clk);
            #1;

            RE = 1;
            @(posedge clk);
            #1;
            $display("Testcase 003: WE inhibition (Data should remain 4'hC)");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            WE = 1; data_in = 4'h1; @(posedge clk); #1;

            WE = 1; data_in = 4'h2; @(posedge clk); #1;

            WE = 1; data_in = 4'h3; @(posedge clk); #1;

            WE = 0;
            RE = 1;
            @(posedge clk);
            #1;
            $display("Testcase 004: Successive overwrites (Final data 4'h3)");
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            WE = 1;
            data_in = 4'h9;
            @(posedge clk);
            #1;

            WE = 0;
            RE = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            RE = 1;
            @(posedge clk);
            #1;
            $display("Testcase 005: Read after idle cycles");
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,RE, WE, clk, data_in, data_out);
    end

endmodule
