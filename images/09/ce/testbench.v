`timescale 1ns/1ps

module temp_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [6:0] temperature;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .alert(alert)
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
            $display("\nTest Case %0d: Normal temperature (25)", test_num);
            reset_dut();
            temperature = 7'd25;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary condition (100)", test_num);
            reset_dut();
            temperature = 7'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alert threshold (101)", test_num);
            reset_dut();
            temperature = 7'd101;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum value (127)", test_num);
            reset_dut();
            temperature = 7'd127;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum value (0)", test_num);
            reset_dut();
            temperature = 7'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range value (50)", test_num);
            reset_dut();
            temperature = 7'd50;
            @(posedge clk);
            #1 #1;
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
        $display("temp_sensor_controller Testbench");
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
        input expected_alert;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
        $dumpvars(0,clk, reset, temperature, alert);
    end

endmodule
