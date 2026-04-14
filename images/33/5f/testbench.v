`timescale 1ns/1ps

module temperature_monitor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] temperature;
    wire [2:0] alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_monitor dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .alarm(alarm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 4'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Temperature (0)", test_num);
        temperature = 4'd0;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature at Threshold (10)", test_num);
        temperature = 4'd10;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature Exceeds Threshold (11)", test_num);
        temperature = 4'd11;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Temperature (15)", test_num);
        temperature = 4'd15;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range Below Threshold (7)", test_num);
        temperature = 4'd7;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Reset behavior during Alarm condition", test_num);

        temperature = 4'd14;
        @(posedge clk);
        #1;

        reset = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(3'b000);
        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_monitor Testbench");
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
        input [2:0] expected_alarm;
        begin
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: alarm=%h",
                         alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%h",
                         expected_alarm);
                $display("  Got:      alarm=%h",
                         alarm);
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
        $dumpvars(0,clk, reset, temperature, alarm);
    end

endmodule
