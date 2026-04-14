`timescale 1ns/1ps

module DRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d_in;
    reg ren;
    reg wen;
    wire [15:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DRAM_Cell dut (
        .clk(clk),
        .d_in(d_in),
        .ren(ren),
        .wen(wen),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            ren = 0;
            d_in = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read");

            wen = 1;
            d_in = 16'hA5A5;
            @(posedge clk);
            #1;
            wen = 0;

            ren = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
            ren = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Overwriting data");

            wen = 1; d_in = 16'h1111;
            @(posedge clk); #1;

            d_in = 16'h2222;
            @(posedge clk); #1;
            wen = 0;

            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h2222);
            ren = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Write Enable (WEN) check");

            wen = 1; d_in = 16'hCAFE;
            @(posedge clk); #1;

            wen = 0; d_in = 16'hBABE;
            @(posedge clk); #1;

            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hCAFE);
            ren = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Boundary Test - All Ones");
            wen = 1; d_in = 16'hFFFF;
            @(posedge clk); #1;
            wen = 0;
            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hFFFF);
            ren = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Boundary Test - All Zeros");

            wen = 1; d_in = 16'hFFFF;
            @(posedge clk); #1;

            d_in = 16'h0000;
            @(posedge clk); #1;
            wen = 0;
            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h0000);
            ren = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Persistence over multiple cycles");

            wen = 1; d_in = 16'h1234;
            @(posedge clk); #1;
            wen = 0;

            repeat(3) @(posedge clk);
            #1;

            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h1234);
            ren = 0;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Toggle pattern 0x5555");
            wen = 1; d_in = 16'h5555;
            @(posedge clk); #1;
            wen = 0;
            ren = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h5555);
            ren = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DRAM_Cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,clk, d_in, ren, wen, d_out);
    end

endmodule
