`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .A(A),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        WE = 0;
        forever #5 WE = ~WE;
    end

        task reset_dut;

        begin
            A = 0;
            D = 0;

            @(negedge WE);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read at Address 0");


            A = 4'h0;
            D = 16'hAAAA;


            @(posedge WE);
            @(negedge WE);

            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Boundary Address (15)");

            A = 4'hF;
            D = 16'h5555;

            @(posedge WE);
            @(negedge WE);

            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Overwrite Address 8");


            A = 4'h8; D = 16'h1234;
            @(posedge WE);
            @(negedge WE);


            A = 4'h8; D = 16'h4321;
            @(posedge WE);
            @(negedge WE);

            #1;
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verify Address Integrity (Addr 5 vs Addr 6)");


            A = 4'h5; D = 16'h5555;
            @(posedge WE);
            @(negedge WE);


            A = 4'h6; D = 16'h6666;
            @(posedge WE);
            @(negedge WE);


            A = 4'h5;
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Data Retention Test");

            A = 4'hA; D = 16'hBEEF;
            @(posedge WE);
            @(negedge WE);


            A = 4'h0;
            repeat(2) @(posedge WE);


            @(negedge WE);
            A = 4'hA;
            #1;
            #1;

            check_outputs(16'hBEEF);
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
        $dumpvars(0,A, D, WE, Q);
    end

endmodule
