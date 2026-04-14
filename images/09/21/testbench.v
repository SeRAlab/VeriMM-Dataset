`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [6:0] temperature;
    wire [3:0] frequency;
    wire [3:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .frequency(frequency),
        .voltage(voltage)
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
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature < 40 (T=25)", test_num);
            reset_dut();
            temperature = 25;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd10, 4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature boundary (T=40)", test_num);
            reset_dut();
            temperature = 40;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15, 4'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature mid range (T=55)", test_num);
            reset_dut();
            temperature = 55;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15, 4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature boundary (T=69)", test_num);
            reset_dut();
            temperature = 69;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15, 4'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature boundary (T=70)", test_num);
            reset_dut();
            temperature = 70;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd4, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Temperature high range (T=90)", test_num);
            reset_dut();
            temperature = 90;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd4, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State retention/Synchronous check", test_num);
            reset_dut();

            temperature = 20;
            @(posedge clk);
            #1;


            temperature = 80;
            #1;

            #1;


            check_outputs(4'd10, 4'd10);


            @(posedge clk);
            #1 #1;
 check_outputs(4'd4, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Absolute temperature limits (0 and 100)", test_num);
            reset_dut();
            temperature = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd10, 4'd10);

            temperature = 100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd4, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [3:0] expected_frequency;
        input [3:0] expected_voltage;
        begin
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
        $dumpvars(0,clk, reset, temperature, frequency, voltage);
    end

endmodule
