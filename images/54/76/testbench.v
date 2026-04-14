`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .reset_n(reset_n),
        .gray(gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check...");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Increment...");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Three Increments...");
            reset_dut();
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Seven Increments...");
            reset_dut();
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Ten Increments...");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Fifteen Increments (Max Count)...");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Wraparound (16 pulses)...");
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Wraparound + 2 pulses (18 pulses)...");
            reset_dut();
            repeat(18) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Asynchronous Reset Mid-Operation...");
            reset_dut();
            repeat(5) @(posedge clk);
            #2;
            reset_n = 0;
            #1;

            #1;


            check_outputs(4'b0000);
            reset_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [3:0] expected_gray;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
        $dumpvars(0,clk, reset_n, gray);
    end

endmodule
