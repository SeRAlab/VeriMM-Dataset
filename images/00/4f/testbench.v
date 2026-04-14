`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg WL;
    reg clk;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .WL(WL),
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
            D = 0;
            WL = 1;
            @(posedge clk);
            #1;
            WL = 0;
            D = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read '1'");
            reset_dut();

            D = 1;
            WL = 1;
            @(posedge clk);
            #1;
            WL = 0;
            D = 0;
            @(posedge clk);
            #1;

            WL = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write and Read '0'");
            reset_dut();

            D = 1;
            WL = 1;
            @(posedge clk);
            #1;

            D = 0;
            WL = 1;
            @(posedge clk);
            #1;
            WL = 0;
            @(posedge clk);
            #1;

            WL = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Word Line Isolation");
            reset_dut();

            D = 1;
            WL = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            WL = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Data Retention (Refresh Simulation)");
            reset_dut();

            D = 1;
            WL = 1;
            @(posedge clk);
            #1;
            WL = 0;
            D = 0;

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            WL = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite Value");
            reset_dut();

            D = 1; WL = 1;
            @(posedge clk); #1;

            D = 0; WL = 1;
            @(posedge clk); #1;

            D = 1; WL = 1;
            @(posedge clk); #1;
            WL = 0;
            @(posedge clk); #1;

            WL = 1;
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,D, WL, clk, Q);
    end

endmodule
