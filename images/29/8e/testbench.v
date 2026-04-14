`timescale 1ns/1ps

module PLL_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frequency_in;
    reg reset;
    wire [7:0] frequency_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL dut (
        .clk(clk),
        .frequency_in(frequency_in),
        .reset(reset),
        .frequency_out(frequency_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frequency_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range frequency locking", test_num);
            reset_dut();
            frequency_in = 8'h40;

            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High frequency locking", test_num);
            reset_dut();
            frequency_in = 8'hFF;
            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low frequency locking", test_num);
            reset_dut();
            frequency_in = 8'h05;
            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero frequency locking", test_num);
            reset_dut();
            frequency_in = 8'h00;
            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bit pattern locking", test_num);
            reset_dut();
            frequency_in = 8'hAA;
            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Inverse alternating bit pattern locking", test_num);
            reset_dut();
            frequency_in = 8'h55;
            repeat (200) @(posedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL Testbench");
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
        input [7:0] expected_frequency_out;
        begin
            if (expected_frequency_out === (expected_frequency_out ^ frequency_out ^ expected_frequency_out)) begin
                $display("PASS");
                $display("  Outputs: frequency_out=%h",
                         frequency_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_out=%h",
                         expected_frequency_out);
                $display("  Got:      frequency_out=%h",
                         frequency_out);
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
        $dumpvars(0,clk, frequency_in, reset, frequency_out);
    end

endmodule
