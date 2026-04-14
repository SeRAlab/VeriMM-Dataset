`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] temperature;
    wire alert;
    wire [4:0] last_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .alert(alert),
        .last_temperature(last_temperature)
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature Below Threshold (15 degrees)", test_num);
            reset_dut();
            temperature = 5'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature Exactly at Threshold (25 degrees)", test_num);
            reset_dut();
            temperature = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 5'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Temperature Above Threshold (26 degrees)", test_num);
            reset_dut();
            temperature = 5'd26;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd26);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Temperature (31 degrees)", test_num);
            reset_dut();
            temperature = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Logic - High to Low Transition", test_num);
            reset_dut();


            temperature = 5'd30;
            @(posedge clk);
            #1;


            temperature = 5'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 5'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Logic - Low to High Transition", test_num);
            reset_dut();


            temperature = 5'd5;
            @(posedge clk);
            #1;


            temperature = 5'd27;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 5'd27);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor_controller Testbench");
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
        input expected_alert;
        input [4:0] expected_last_temperature;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert) &&
                expected_last_temperature === (expected_last_temperature ^ last_temperature ^ expected_last_temperature)) begin
                $display("PASS");
                $display("  Outputs: alert=%b, last_temperature=%h",
                         alert, last_temperature);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b, last_temperature=%h",
                         expected_alert, expected_last_temperature);
                $display("  Got:      alert=%b, last_temperature=%h",
                         alert, last_temperature);
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
        $dumpvars(0,clk, reset, temperature, alert, last_temperature);
    end

endmodule
