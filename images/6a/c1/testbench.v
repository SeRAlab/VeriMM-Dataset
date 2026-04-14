`timescale 1ns/1ps

module counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] data_in;
    reg load;
    wire [8:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            data_in <= 9'd0;
            @(posedge clk);
            load <= 0;
            data_in <= 9'd0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic counting from zero...");
            reset_dut();
            repeat (10) @(posedge clk);
            #1;

            check_outputs(9'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 9'h0A5 and count 5 cycles...");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 9'h0A5;
            @(posedge clk);
            load <= 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(9'd170);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Check overflow from 511 to 0...");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 9'd511;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load 511 and count 3 cycles...");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 9'd511;
            @(posedge clk);
            load <= 0;
            repeat (3) @(posedge clk);
            #1;

            check_outputs(9'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify load priority over counting...");
            reset_dut();
            repeat (5) @(posedge clk);
            load <= 1;
            data_in <= 9'd200;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(9'd200);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Count 256 cycles from 0...");
            reset_dut();
            repeat (256) @(posedge clk);
            #1;

            check_outputs(9'd256);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_load Testbench");
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
        input [8:0] expected_count;
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
        $dumpvars(0,clk, data_in, load, count);
    end

endmodule
