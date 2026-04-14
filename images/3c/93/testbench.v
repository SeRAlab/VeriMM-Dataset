`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd;
    reg reset;
    wire sd_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .cmd(cmd),
        .reset(reset),
        .sd_busy(sd_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cmd = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic Reset Check");
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Read Command (3 Busy Cycles)");
            reset_dut();
            cmd = 1;
            @(posedge clk);
            #1;
            if (sd_busy !== 1) $display("  Error: sd_busy did not go high for Read");


            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Write Command (5 Busy Cycles)");
            reset_dut();
            cmd = 0;
            @(posedge clk);
            #1;
            if (sd_busy !== 1) $display("  Error: sd_busy did not go high for Write");


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Reset During Active Write");
            reset_dut();
            cmd = 0;
            @(posedge clk);
            #1;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Consecutive Read and Write");
            reset_dut();


            cmd = 1;
            @(posedge clk);
            repeat(3) @(posedge clk);
            #1;


            cmd = 0;
            @(posedge clk);
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input expected_sd_busy;
        begin
            if (expected_sd_busy === (expected_sd_busy ^ sd_busy ^ expected_sd_busy)) begin
                $display("PASS");
                $display("  Outputs: sd_busy=%b",
                         sd_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sd_busy=%b",
                         expected_sd_busy);
                $display("  Got:      sd_busy=%b",
                         sd_busy);
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
        $dumpvars(0,clk, cmd, reset, sd_busy);
    end

endmodule
