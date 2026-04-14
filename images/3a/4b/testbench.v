`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        D = 4'h0;
        RE = 0;
        WE = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Write/Read (0xA)");
        reset_dut();
        test_num = test_num + 1;


        WE = 1;
        D = 4'hA;
        @(posedge clk);
        #1;
        WE = 0;


        RE = 1;
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Basic Write/Read (0x5)");
        reset_dut();
        test_num = test_num + 1;


        WE = 1;
        D = 4'h5;
        @(posedge clk);
        #1;
        WE = 0;


        RE = 1;
        #2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Data Retention (WE gating)");
        reset_dut();
        test_num = test_num + 1;


        WE = 1;
        D = 4'hC;
        @(posedge clk);
        #1;


        WE = 0;
        D = 4'h3;
        @(posedge clk);
        #1;


        RE = 1;
        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Read Enable Gating");
        reset_dut();
        test_num = test_num + 1;


        WE = 1;
        D = 4'hF;
        @(posedge clk);
        #1;
        WE = 0;


        RE = 0;
        #2;


        #1;



        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Overwrite functionality");
        reset_dut();
        test_num = test_num + 1;


        WE = 1;
        D = 4'h1;
        @(posedge clk);
        #1;


        D = 4'hE;
        @(posedge clk);
        #1;
        WE = 0;


        RE = 1;
        #2;
        #1;

        check_outputs(4'hE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,D, RE, WE, clk, Q);
    end

endmodule
