`timescale 1ns/1ps

module temp_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg shutdown_signal;
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
        .shutdown_signal(shutdown_signal),
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
            shutdown_signal = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature below threshold (70C)", test_num);
            reset_dut();

            temperature = 70;
            shutdown_signal = 0;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature above threshold (80C) - Verification of 5 cycle delay", test_num);
            reset_dut();

            temperature = 80;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature trigger interrupted by reset", test_num);
            reset_dut();

            temperature = 85;
            repeat(3) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: External shutdown_signal trigger", test_num);
            reset_dut();

            temperature = 25;
            shutdown_signal = 1;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset clears active shutdown state", test_num);
            reset_dut();


            temperature = 90;
            repeat(6) @(posedge clk);


            if (shutdown !== 1'b1) $display("Error: Shutdown failed to trigger");


            reset = 1;
            #1;

            #1;


            check_outputs(1'b0);


            @(posedge clk) reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Temperature exactly at threshold (75C)", test_num);
            reset_dut();

            temperature = 75;
            repeat(10) @(posedge clk);



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verification that shutdown is NOT active at cycle 4", test_num);
            reset_dut();

            temperature = 100;
            repeat(4) @(posedge clk);
            #1;

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
        $dumpvars(0,clk, reset, shutdown_signal, temperature, shutdown);
    end

endmodule
