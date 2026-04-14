`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] AddrA;
    reg CEN;
    reg [7:0] DI;
    reg WE;
    reg clk;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AddrA(AddrA),
        .CEN(CEN),
        .DI(DI),
        .WE(WE),
        .clk(clk),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            AddrA = 0;
            CEN = 0;
            DI = 0;
            WE = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read to Addr 0");
            reset_dut();

            AddrA = 3'h0; DI = 8'hA5; CEN = 1; WE = 1;
            @(posedge clk);
            #1;

            WE = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write and Read to Addr 7");
            reset_dut();

            AddrA = 3'h7; DI = 8'h5A; CEN = 1; WE = 1;
            @(posedge clk);
            #1;

            WE = 0;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: CEN Disable Check");
            reset_dut();

            AddrA = 3'h1; DI = 8'h00; CEN = 1; WE = 1;
            @(posedge clk); #1;

            AddrA = 3'h1; DI = 8'hFF; CEN = 0; WE = 1;
            @(posedge clk); #1;

            CEN = 1; WE = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: WE Disable Check");
            reset_dut();

            AddrA = 3'h2; DI = 8'h11; CEN = 1; WE = 1;
            @(posedge clk); #1;

            AddrA = 3'h2; DI = 8'hEE; CEN = 1; WE = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Read switching check");
            reset_dut();

            AddrA = 3'h1; DI = 8'h11; CEN = 1; WE = 1;
            @(posedge clk); #1;

            AddrA = 3'h2; DI = 8'h22; CEN = 1; WE = 1;
            @(posedge clk); #1;

            WE = 0; CEN = 1;
            AddrA = 3'h1;
            #1;
            #1;

            check_outputs(8'h11);
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,AddrA, CEN, DI, WE, clk, DO);
    end

endmodule
