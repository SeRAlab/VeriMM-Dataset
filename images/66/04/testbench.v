`timescale 1ns/1ps

module ring_counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_8bit dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verifying Reset State");
            reset_dut();
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verifying Single Shift");
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying Enable Signal (en=0)");
            reset_dut();
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verifying Full Rotation (8 shifts)");
            reset_dut();
            en = 1;
            repeat(8) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying shift to MSB (7 shifts)");
            reset_dut();
            en = 1;
            repeat(7) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'b1000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verifying Multi-cycle start-stop");
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            en = 0;
            repeat(3) @(posedge clk);
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_8bit Testbench");
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, reset, count);
    end

endmodule
