`timescale 1ns/1ps

module gray_code_counter_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter_6bit dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Synchronous Reset...");
            reset_dut();

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Count = 1...");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Count = 2...");
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000011);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Count = 5...");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000111);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Count = 16...");
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b011000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Count = 31...");
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b010000);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Count = 63 (Max)...");
            reset_dut();
            repeat(63) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Wrap Around...");
            reset_dut();
            repeat(64) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter_6bit Testbench");
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, rst, count);
    end

endmodule
