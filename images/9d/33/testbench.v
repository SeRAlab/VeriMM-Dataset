`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
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
        reset_n = 1'b1;
        @(negedge clk);
        reset_n = 1'b0;
        @(posedge clk);
        #1;
        reset_n = 1'b1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking Reset State...");
        reset_dut();
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Checking 1 Clock Cycle...");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(7'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Checking 6 Clock Cycles...");
        reset_dut();
        repeat(6) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Checking 7 Clock Cycles (Full Fill)...");
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Checking 8 Clock Cycles...");
        reset_dut();
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h7E);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Checking 13 Clock Cycles...");
        reset_dut();
        repeat(13) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h40);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Checking 14 Clock Cycles (Complete Cycle)...");
        reset_dut();
        repeat(14) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Checking 15 Clock Cycles (Wrap Around)...");
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(7'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, reset_n, q);
    end

endmodule
