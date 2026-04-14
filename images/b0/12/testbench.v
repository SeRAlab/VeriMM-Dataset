`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            force dut.count = 3'b111;
            #10;
            release dut.count;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Single decrement test");
            reset_dut();
            enable = 1;
            @(negedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Enable=0 test");
            reset_dut();
            enable = 0;
            @(negedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Triple decrement test (7 -> 4)");
            reset_dut();
            enable = 1;
            repeat(3) @(negedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Wrap around test (7 -> 0 -> 7)");
            reset_dut();
            enable = 1;
            repeat(8) @(negedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Intermittent enable test");
            reset_dut();
            enable = 1;
            @(negedge clk);
            enable = 0;
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [2:0] expected_count;
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
        $dumpvars(0,clk, enable, count);
    end

endmodule
