`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire [2:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .fan_speed(fan_speed)
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
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature < 20 (T=10)", test_num);
            reset_dut();
            temperature = 10;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature < 20 (T=19)", test_num);
            reset_dut();
            temperature = 19;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 20-40 (T=20)", test_num);
            reset_dut();
            temperature = 20;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 20-40 (T=30)", test_num);
            reset_dut();
            temperature = 30;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 20-40 (T=39)", test_num);
            reset_dut();
            temperature = 39;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 40-60 (T=40)", test_num);
            reset_dut();
            temperature = 40;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 40-60 (T=50)", test_num);
            reset_dut();
            temperature = 50;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 40-60 (T=59)", test_num);
            reset_dut();
            temperature = 59;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 60-80 (T=60)", test_num);
            reset_dut();
            temperature = 60;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 60-80 (T=70)", test_num);
            reset_dut();
            temperature = 70;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature 60-80 (T=79)", test_num);
            reset_dut();
            temperature = 79;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature > 80 (T=80)", test_num);
            reset_dut();
            temperature = 80;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temperature > 80 (T=95)", test_num);
            reset_dut();
            temperature = 95;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset = 1;
            temperature = 95;
            @(posedge clk);
            #1;

            if (fan_speed === 3'b000) begin
                $display("PASS: Reset speed is 000");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset speed is %h", fan_speed);
                fail_count = fail_count + 1;
            end
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
        $display("fan_speed_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input [2:0] expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
        $dumpvars(0,clk, reset, temperature, fan_speed);
    end

endmodule
