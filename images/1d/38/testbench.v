`timescale 1ns/1ps

module temp_monitor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] temperature;
    wire warning;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_monitor dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .warning(warning)
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
            $display("Testcase %03d: System Reset State", test_num);
            reset_dut();
            temperature = 20;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Trigger Warning High", test_num);
            reset_dut();
            temperature = 26;
            @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Exactly at High Threshold", test_num);
            reset_dut();
            temperature = 25;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hysteresis Band (Staying High)", test_num);
            reset_dut();

            temperature = 30;
            @(posedge clk);

            temperature = 24;
            @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Trigger Warning Low", test_num);
            reset_dut();

            temperature = 30;
            @(posedge clk);

            temperature = 22;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Hysteresis Band (Staying Low)", test_num);
            reset_dut();

            temperature = 20;
            @(posedge clk);

            temperature = 24;
            @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Exactly at Low Threshold", test_num);
            reset_dut();

            temperature = 28;
            @(posedge clk);

            temperature = 23;
            @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset Override", test_num);
            reset_dut();
            temperature = 31;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
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
        $display("temp_monitor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_warning;
        begin
            if (expected_warning === (expected_warning ^ warning ^ expected_warning)) begin
                $display("PASS");
                $display("  Outputs: warning=%b",
                         warning);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: warning=%b",
                         expected_warning);
                $display("  Got:      warning=%b",
                         warning);
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
        $dumpvars(0,clk, reset, temperature, warning);
    end

endmodule
