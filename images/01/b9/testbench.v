`timescale 1ns/1ps

module temp_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire shutdown_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_shutdown dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .shutdown_signal(shutdown_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        temperature = 25;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Normal temperature (below 75)", test_num);
        reset_dut();
        temperature = 45;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Temperature exceeds threshold (80 > 75)", test_num);
        reset_dut();
        temperature = 80;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Sticky shutdown signal check", test_num);
        reset_dut();
        temperature = 85;
        @(posedge clk);
        temperature = 40;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset when temperature is low", test_num);
        reset_dut();
        temperature = 90;
        @(posedge clk);
        temperature = 50;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Boundary check (exactly 75)", test_num);
        reset_dut();
        temperature = 75;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset while temperature remains high", test_num);
        reset_dut();
        temperature = 100;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Maximum temperature (255)", test_num);
        reset_dut();
        temperature = 8'hFF;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_shutdown Testbench");
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
        input expected_shutdown_signal;
        begin
            if (expected_shutdown_signal === (expected_shutdown_signal ^ shutdown_signal ^ expected_shutdown_signal)) begin
                $display("PASS");
                $display("  Outputs: shutdown_signal=%b",
                         shutdown_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown_signal=%b",
                         expected_shutdown_signal);
                $display("  Got:      shutdown_signal=%b",
                         shutdown_signal);
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
        $dumpvars(0,clk, reset, temperature, shutdown_signal);
    end

endmodule
