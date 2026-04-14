`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    reg load;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .D(D),
        .clk(clk),
        .load(load),
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
            reset = 1;
            load = 0;
            D = 4'b0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset");
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Synchronous Load");
            reset_dut();
            D = 4'hA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking Increment");
            reset_dut();

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking Rollover");
            reset_dut();

            D = 4'd15;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking Load Priority over Count");
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            D = 4'h7;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking Consecutive Loads");
            reset_dut();
            load = 1;
            D = 4'h3;
            @(posedge clk);
            #1;
            D = 4'hE;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Checking Increment after Load");
            reset_dut();
            D = 4'hB;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Checking Asynchronous Reset Mid-cycle");
            reset_dut();
            repeat(3) @(posedge clk);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(4'd0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [3:0] expected_count;
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
        $dumpvars(0,D, clk, load, reset, count);
    end

endmodule
