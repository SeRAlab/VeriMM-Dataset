`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] M;
    reg [3:0] N;
    reg clk;
    reg rst;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .M(M),
        .N(N),
        .clk(clk),
        .rst(rst),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            M = 0;
            N = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: M=4, N=2 - Checking pulse High phase", test_num);
            M = 4; N = 2;
            reset_dut();

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: M=4, N=2 - Checking pulse Low phase", test_num);
            M = 4; N = 2;
            reset_dut();


            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: M=5, N=1 - Checking single cycle pulse", test_num);
            M = 5; N = 1;
            reset_dut();

            @(posedge clk);
            #2;
            if (pulse !== 1'b1) $display("Error: Expected high at start");

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: M=3, N=3 - Checking continuous pulse", test_num);
            M = 3; N = 3;
            reset_dut();

            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: M=4, N=2 - Checking wrap-around behavior", test_num);
            M = 4; N = 2;
            reset_dut();

            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: M=15, N=1 - Checking late low phase", test_num);
            M = 15; N = 1;
            reset_dut();

            repeat(14) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pulse_generator Testbench");
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,M, N, clk, rst, pulse);
    end

endmodule
