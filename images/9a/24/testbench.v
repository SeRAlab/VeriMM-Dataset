`timescale 1ns/1ps

module up_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_4bit dut (
        .clk(clk),
        .en(en),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            test_num = test_num + 1;


            for (i = 0; i < 16; i = i + 1) begin
                if (count === 4'h0)
                    en = 0;
                else
                    en = 1;
                @(posedge clk);
            end
            en = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Counter idle (en=0)");
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Single increment (en=1 for 1 cycle)");
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Multiple increments (en=1 for 7 cycles)");
            en = 1;
            repeat(7) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Wrap-around check (en=1 for 16 cycles)");
            en = 1;
            repeat(16) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Count to max (en=1 for 15 cycles)");
            en = 1;
            repeat(15) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Pause and resume counter");
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(3) @(posedge clk);
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_4bit Testbench");
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
        $dumpvars(0,clk, en, count);
    end

endmodule
