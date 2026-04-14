`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;
    reg clk;
    wire [31:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .WD(WD),
        .WE(WE),
        .clk(clk),
        .RD(RD)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 32'h0;
            WD = 32'h0;
            WE = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();
            @(negedge clk);
            A = 32'h0000_0000;
            WD = 32'hDEADBEEF;
            WE = 1;
            @(negedge clk);
            WE = 0;
            A = 32'h0000_0000;
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Address Access...");
            reset_dut();

            @(negedge clk);
            A = 32'd4;
            WD = 32'h1111_1111;
            WE = 1;

            @(negedge clk);
            A = 32'd8;
            WD = 32'h2222_2222;
            WE = 1;
            @(negedge clk);
            WE = 0;
            A = 32'd4;
            #1;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Address Aliasing (A[6:2] only)...");
            reset_dut();

            @(negedge clk);
            A = 32'd20;
            WD = 32'hCAFEBABE;
            WE = 1;
            @(negedge clk);
            WE = 0;


            A = 32'hFFFF_FF97;
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Check...");
            reset_dut();

            @(negedge clk);
            A = 32'd12;
            WD = 32'h5555_AAAA;
            WE = 1;
            @(negedge clk);

            WE = 0;
            WD = 32'hFFFF_FFFF;
            @(negedge clk);
            A = 32'd12;
            #1;

            #1;


            check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary and Overwrite...");
            reset_dut();

            @(negedge clk);
            A = 32'd124;
            WD = 32'h0000_0001;
            WE = 1;
            @(negedge clk);

            WD = 32'h8000_0000;
            @(negedge clk);
            WE = 0;
            #1;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_RD;
        begin
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
        $dumpvars(0,A, WD, WE, clk, RD);
    end

endmodule
