`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] D;
    reg RE;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            RE = 0;
            D = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read back");
            reset_dut();


            D = 16'hAAAA;
            WE = 1;
            RE = 0;
            @(posedge CLK);
            #2;


            WE = 0;
            RE = 1;
            D = 16'h0000;
            @(posedge CLK);
            #2;

            test_num = 1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read 16'h5555");
            reset_dut();


            D = 16'h5555;
            WE = 1;
            RE = 0;
            @(posedge CLK);
            #2;


            WE = 0;
            RE = 1;
            D = 16'hFFFF;
            @(posedge CLK);
            #2;

            test_num = 2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Data Retention with WE=0");
            reset_dut();


            D = 16'h1234;
            WE = 1;
            @(posedge CLK);
            #2;


            D = 16'hFFFF;
            WE = 0;
            @(posedge CLK);
            #2;


            RE = 1;
            @(posedge CLK);
            #2;

            test_num = 3;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Write and Read");
            reset_dut();


            D = 16'hBEEF;
            WE = 1;
            RE = 1;
            @(posedge CLK);
            #2;

            test_num = 4;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive Writes then Read");
            reset_dut();


            D = 16'h1111;
            WE = 1;
            @(posedge CLK);
            #2;


            D = 16'h2222;
            WE = 1;
            @(posedge CLK);
            #2;


            WE = 0;
            RE = 1;
            @(posedge CLK);
            #2;

            test_num = 5;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Extreme values (All 0s and All 1s)");
            reset_dut();


            D = 16'hFFFF;
            WE = 1;
            @(posedge CLK);
            #2;


            D = 16'h0000;
            WE = 1;
            @(posedge CLK);
            #2;


            WE = 0;
            RE = 1;
            @(posedge CLK);
            #2;

            test_num = 6;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [15:0] expected_Q;
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
        $dumpvars(0,CLK, D, RE, WE, Q);
    end

endmodule
