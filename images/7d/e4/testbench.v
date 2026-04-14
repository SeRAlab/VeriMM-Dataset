`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [15:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .reset(reset),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Checking reset state (Seed value)", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Checking state after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Checking state after 4 clock cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Checking feedback transition (15 cycles)", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        reg [15:0] captured_val;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Verification of non-zero stability after 100 cycles", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            if (lfsr !== 16'h0000) begin

                #1;


                check_outputs(lfsr);
            end else begin

                #1;


                check_outputs(16'hDEAD);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [15:0] expected_lfsr;
        begin
            if (expected_lfsr === (expected_lfsr ^ lfsr ^ expected_lfsr)) begin
                $display("PASS");
                $display("  Outputs: lfsr=%h",
                         lfsr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr=%h",
                         expected_lfsr);
                $display("  Got:      lfsr=%h",
                         lfsr);
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
        $dumpvars(0,clk, reset, lfsr);
    end

endmodule
