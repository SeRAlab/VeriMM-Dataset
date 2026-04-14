`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg RE;
    reg WE;
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .RE(RE),
        .WE(WE),
        .addr(addr),
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
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write and Read (Addr 0)");
            reset_dut();
            test_num = 1;


            @(posedge clk);
            WE = 1; RE = 0; addr = 3'h0; data_in = 8'h55;
            @(posedge clk);


            WE = 0; RE = 1; addr = 3'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Multiple Address Integrity (Addr 3 and 7)");
            reset_dut();
            test_num = 2;


            @(posedge clk);
            WE = 1; RE = 0; addr = 3'h3; data_in = 8'hAA;
            @(posedge clk);


            WE = 1; RE = 0; addr = 3'h7; data_in = 8'hCC;
            @(posedge clk);


            WE = 0; RE = 1; addr = 3'h3;
            @(posedge clk);
            #1;

            if (data_out !== 8'hAA) begin
                #1;

                check_outputs(8'hAA);
            end else begin

                WE = 0; RE = 1; addr = 3'h7;
                @(posedge clk);
                #1;
                #1;

                check_outputs(8'hCC);
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write Enable Verification");
            reset_dut();
            test_num = 3;


            @(posedge clk);
            WE = 1; RE = 0; addr = 3'h4; data_in = 8'h11;
            @(posedge clk);


            WE = 0; RE = 0; addr = 3'h4; data_in = 8'h99;
            @(posedge clk);


            WE = 0; RE = 1; addr = 3'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Overwrite Verification");
            reset_dut();
            test_num = 4;


            @(posedge clk);
            WE = 1; RE = 0; addr = 3'h1; data_in = 8'hBB;
            @(posedge clk);


            WE = 1; RE = 0; addr = 3'h1; data_in = 8'hFF;
            @(posedge clk);


            WE = 0; RE = 1; addr = 3'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_8bit Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,RE, WE, addr, clk, data_in, data_out);
    end

endmodule
