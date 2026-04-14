`timescale 1ns/1ps

module temperature_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    reg [7:0] temperature;
    reg [7:0] threshold;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_shutdown dut (
        .clk(clk),
        .enable(enable),
        .rst_n(rst_n),
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
            rst_n = 0;
            enable = 0;
            temperature = 0;
            threshold = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled monitoring (Temp > Threshold)", test_num);
            reset_dut();
            threshold = 8'd50;
            temperature = 8'd100;
            enable = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal operation (Temp < Threshold)", test_num);
            reset_dut();
            threshold = 8'd80;
            temperature = 8'd40;
            enable = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shutdown trigger (Temp > Threshold)", test_num);
            reset_dut();
            threshold = 8'd80;
            temperature = 8'd85;
            enable = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary (Temp == Threshold)", test_num);
            reset_dut();
            threshold = 8'd100;
            temperature = 8'd100;
            enable = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lowering threshold to trigger shutdown", test_num);
            reset_dut();
            enable = 1;
            temperature = 8'd60;
            threshold = 8'd100;
            @(posedge clk);
            threshold = 8'd50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enabling system while at high temp", test_num);
            reset_dut();
            threshold = 8'd70;
            temperature = 8'd90;
            enable = 0;
            @(posedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max temperature values", test_num);
            reset_dut();
            threshold = 8'hFE;
            temperature = 8'hFF;
            enable = 1;
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
        $display("temperature_shutdown Testbench");
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
        $dumpvars(0,clk, enable, rst_n, temperature, threshold, shutdown);
    end

endmodule
