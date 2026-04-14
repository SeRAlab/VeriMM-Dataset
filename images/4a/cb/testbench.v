`timescale 1ns/1ps

module ring_counter_neg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset_n;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_neg dut (
        .clk(clk),
        .en(en),
        .reset_n(reset_n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            en = 0;
            reset_n = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Reset Check");

            #1;


            check_outputs(7'b0000001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Single Shift Check");
            en = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(7'b0000010);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Triple Shift Check");
            en = 1;
            repeat(3) @(negedge clk);
            #2;
            #1;

            check_outputs(7'b0001000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Enable Low (Hold) Check");
            en = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            #2;
            #1;

            check_outputs(7'b0000100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Full Rotation Check");
            en = 1;
            repeat(7) @(negedge clk);
            #2;
            #1;

            check_outputs(7'b0000001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Asynchronous Reset Mid-cycle Check");
            en = 1;
            repeat(4) @(negedge clk);
            #3;
            reset_n = 0;
            #1;
            #1;

            check_outputs(7'b0000001);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Complex Enable Sequence Check");
            en = 1;
            repeat(1) @(negedge clk);
            en = 0;
            repeat(2) @(negedge clk);
            en = 1;
            repeat(4) @(negedge clk);
            #2;
            #1;

            check_outputs(7'b0100000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_neg Testbench");
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
        input [6:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, en, reset_n, q);
    end

endmodule
