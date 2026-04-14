`timescale 1ns/1ps

module temp_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] temp_in;
    wire alert;
    wire [7:0] last_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_controller dut (
        .clk(clk),
        .rst(rst),
        .temp_in(temp_in),
        .alert(alert),
        .last_temp(last_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temp_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Temperature Below Threshold (25 degrees)", test_num);
            reset_dut();
            temp_in = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Temperature Exactly at Threshold (75 degrees)", test_num);
            reset_dut();
            temp_in = 8'd75;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'd75);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Temperature Above Threshold (80 degrees)", test_num);
            reset_dut();
            temp_in = 8'd80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alert Trigger and Clear Sequence", test_num);
            reset_dut();


            temp_in = 8'd90;
            @(posedge clk);
            #1;


            temp_in = 8'd40;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple Sequential Updates", test_num);
            reset_dut();

            temp_in = 8'd30;
            @(posedge clk);
            #1;

            temp_in = 8'd45;
            @(posedge clk);
            #1;

            temp_in = 8'd60;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'd60);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum Input Value (255 degrees)", test_num);
            reset_dut();
            temp_in = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd255);
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
        input [7:0] expected_last_temp;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert) &&
                expected_last_temp === (expected_last_temp ^ last_temp ^ expected_last_temp)) begin
                $display("PASS");
                $display("  Outputs: alert=%b, last_temp=%h",
                         alert, last_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b, last_temp=%h",
                         expected_alert, expected_last_temp);
                $display("  Got:      alert=%b, last_temp=%h",
                         alert, last_temp);
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
        $dumpvars(0,clk, rst, temp_in, alert, last_temp);
    end

endmodule
