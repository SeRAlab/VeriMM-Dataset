`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire [1:0] fan_speed;

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
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            temperature = 8'd15;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 15 (Below 20)", test_num);
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            temperature = 8'd20;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 20 (Boundary Low)", test_num);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            temperature = 8'd35;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 35 (Medium Speed)", test_num);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            temperature = 8'd40;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 40 (Boundary High)", test_num);
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            temperature = 8'd100;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 100 (High Speed)", test_num);
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            temperature = 8'd50;
            @(posedge clk);

            temperature = 8'd25;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature dropped 50 -> 25 (Low Speed)", test_num);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            temperature = 8'd25;
            @(posedge clk);
            #2;
            $display("Test %0d: Temperature = 25 (Low Speed)", test_num);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            temperature = 8'd45;
            @(posedge clk);
            #2;
            reset = 1;
            #1;
            $display("Test %0d: Asynchronous Reset during High Speed", test_num);
            #1;

            check_outputs(2'd0);
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
        input [1:0] expected_fan_speed;
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
