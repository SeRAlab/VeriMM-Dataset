`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] N;
    reg clk;
    reg start;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .N(N),
        .clk(clk),
        .start(start),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        start = 0;
        N = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=3, Verify pulse is HIGH during its duration", test_num);
        reset_dut();
        N = 3;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(N-1) @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=3, Verify pulse returns to LOW after N cycles", test_num);
        reset_dut();
        N = 3;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(N) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=1, Verify pulse returns to LOW after 1 cycle", test_num);
        reset_dut();
        N = 1;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(1) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=8, Verify medium length pulse duration", test_num);
        reset_dut();
        N = 8;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(N) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=15, Verify maximum 4-bit width pulse duration", test_num);
        reset_dut();
        N = 15;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(N) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: N=4, Multiple start pulses during operation", test_num);
        reset_dut();
        N = 4;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(2) @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        repeat(2) @(posedge clk);
        #2;
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
        $dumpvars(0,N, clk, start, pulse);
    end

endmodule
