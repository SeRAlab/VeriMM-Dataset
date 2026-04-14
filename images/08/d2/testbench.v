`timescale 1ns/1ps

module temp_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    reg [7:0] threshold;
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
        .threshold(threshold),
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
            threshold = 8'hFF;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Temperature below threshold (Normal Condition)", test_num);
            threshold = 8'd50;
            temperature = 8'd25;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Temperature equals threshold (Boundary Condition)", test_num);
            threshold = 8'd50;
            temperature = 8'd50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Temperature exceeds threshold (Trigger Condition)", test_num);
            threshold = 8'd50;
            temperature = 8'd55;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Latch behavior check (Temp drops after trigger)", test_num);
            threshold = 8'd50;
            temperature = 8'd60;
            @(posedge clk);
            temperature = 8'd20;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Reset clearing shutdown signal", test_num);
            threshold = 8'd50;
            temperature = 8'd70;
            @(posedge clk);

            temperature = 8'd30;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Trigger via lowering threshold", test_num);
            temperature = 8'd40;
            threshold = 8'd100;
            @(posedge clk);
            threshold = 8'd30;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Extreme values (Max temp and threshold)", test_num);
            threshold = 8'hFE;
            temperature = 8'hFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        $dumpvars(0,clk, reset, temperature, threshold, shutdown);
    end

endmodule
