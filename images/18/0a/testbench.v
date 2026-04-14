`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg RE;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
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
            D = 4'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read (4'hA)");
            reset_dut();


            WE = 1; D = 4'hA;
            @(posedge CLK);
            #1 WE = 0;


            RE = 1;
            @(negedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Data Retention after Read");
            reset_dut();


            WE = 1; D = 4'h5;
            @(posedge CLK);
            #1 WE = 0;


            RE = 1;
            @(negedge CLK);
            #1 RE = 0;


            @(posedge CLK);
            @(negedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting data (4'h1 -> 4'hF)");
            reset_dut();


            WE = 1; D = 4'h1;
            @(posedge CLK);


            D = 4'hF;
            @(posedge CLK);
            #1 WE = 0;


            RE = 1;
            @(negedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: WE=0 prevents writing");
            reset_dut();


            WE = 1; D = 4'h3;
            @(posedge CLK);


            #1 WE = 0; D = 4'hE;
            @(posedge CLK);


            #1 RE = 1;
            @(negedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Same-cycle Write and Read");
            reset_dut();


            WE = 1; RE = 1; D = 4'h8;

            @(posedge CLK);
            @(negedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        $dumpvars(0,CLK, D, RE, WE, Q);
    end

endmodule
