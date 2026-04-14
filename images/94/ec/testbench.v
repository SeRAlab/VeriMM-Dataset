`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DI;
    reg [3:0] RAD;
    reg [3:0] WAD;
    reg WCK;
    reg WRE;
    wire [3:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DI(DI),
        .RAD(RAD),
        .WAD(WAD),
        .WCK(WCK),
        .WRE(WRE),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        WCK = 0;
        forever #5 WCK = ~WCK;
    end

        task reset_dut;

        begin
            DI = 4'd0;
            RAD = 4'd0;
            WAD = 4'd0;
            WRE = 0;
            @(posedge WCK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Write and Read back");
            reset_dut();


            WAD = 4'h4;
            DI = 4'hA;
            WRE = 1;
            @(posedge WCK);
            #1;
            WRE = 0;


            RAD = 4'h4;
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Verifying Write Enable (WRE=0 should not write)");
            reset_dut();


            WAD = 4'h8;
            DI = 4'h5;
            WRE = 1;
            @(posedge WCK);
            #1;


            DI = 4'hF;
            WRE = 0;
            @(posedge WCK);
            #1;


            RAD = 4'h8;
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Overwriting an existing memory location");
            reset_dut();


            WAD = 4'h2;
            DI = 4'h1;
            WRE = 1;
            @(posedge WCK);
            #1;


            DI = 4'hE;
            @(posedge WCK);
            #1;
            WRE = 0;

            RAD = 4'h2;
            #2;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Writing and reading at the highest address (0xF)");
            reset_dut();

            WAD = 4'hF;
            DI = 4'h7;
            WRE = 1;
            @(posedge WCK);
            #1;
            WRE = 0;

            RAD = 4'hF;
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Simultaneous Read and Write at different addresses");
            reset_dut();


            WAD = 4'h0;
            DI = 4'hC;
            WRE = 1;
            @(posedge WCK);
            #1;


            WAD = 4'h1;
            DI = 4'hB;
            RAD = 4'h0;
            @(posedge WCK);
            #1;
            WRE = 0;

            #2;
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_DO;
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
        $dumpvars(0,DI, RAD, WAD, WCK, WRE, DO);
    end

endmodule
