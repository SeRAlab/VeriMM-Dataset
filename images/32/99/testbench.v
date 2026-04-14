`timescale 1ns/1ps

module temp_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_shutdown dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Below Threshold", test_num);
            reset_dut();
            temperature = 50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: At Threshold Boundary (75)", test_num);
            reset_dut();
            temperature = 75;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Exceeding Threshold (80)", test_num);
            reset_dut();
            temperature = 80;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shutdown Persistence after cooling", test_num);
            reset_dut();
            temperature = 90;
            @(posedge clk);
            temperature = 60;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Successful Reset (Temp < 75)", test_num);
            reset_dut();
            temperature = 85;
            @(posedge clk);
            temperature = 40;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Failed Reset (Temp > 75)", test_num);
            reset_dut();
            temperature = 85;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
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
        input expected_shutdown;
        begin
            if (expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown)) begin
                $display("PASS");
                $display("  Outputs: shutdown=%b",
                         shutdown);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown=%b",
                         expected_shutdown);
                $display("  Got:      shutdown=%b",
                         shutdown);
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
        $dumpvars(0,clk, reset, temperature, shutdown);
    end

endmodule
