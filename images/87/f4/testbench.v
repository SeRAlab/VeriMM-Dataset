`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    reg load;
    reg [1:0] value;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .load(load),
        .value(value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            load = 0;
            value = 2'b00;
            @(posedge clk);
            #1;
            clear = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Testing Synchronous Clear");
            reset_dut();

            load = 1;
            value = 2'b11;
            @(posedge clk);
            #1;
            load = 0;

            clear = 1;
            @(posedge clk);
            #1;
            clear = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing Load");
            reset_dut();
            load = 1;
            value = 2'b10;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing Increment");
            reset_dut();
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Testing Enable Toggle (Hold Value)");
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing Wrap Around (3 -> 0)");
            reset_dut();
            load = 1;
            value = 2'b11;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing Priority (Clear over Load)");
            reset_dut();
            clear = 1;
            load = 1;
            value = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Testing Priority (Load over Enable)");
            reset_dut();
            load = 1;
            value = 2'b01;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [1:0] expected_count;
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
        $dumpvars(0,clear, clk, enable, load, value, count);
    end

endmodule
