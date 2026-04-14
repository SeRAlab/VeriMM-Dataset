`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cal_factor;
    reg clk;
    reg [7:0] input_temp;
    wire [7:0] output_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .cal_factor(cal_factor),
        .clk(clk),
        .input_temp(input_temp),
        .output_temp(output_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_temp = 8'h0;
            cal_factor = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Simple positive adjustment", test_num);
            input_temp = 8'd25;
            cal_factor = 8'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Zero calibration factor", test_num);
            input_temp = 8'd50;
            cal_factor = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Large input value", test_num);
            input_temp = 8'd150;
            cal_factor = 8'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd170);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overflow condition", test_num);
            input_temp = 8'd250;
            cal_factor = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Zero input temperature", test_num);
            input_temp = 8'd0;
            cal_factor = 8'd12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Negative adjustment simulation (wrap-around)", test_num);
            input_temp = 8'd100;
            cal_factor = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd99);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Max values check", test_num);
            input_temp = 8'hFF;
            cal_factor = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
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
        input [7:0] expected_output_temp;
        begin
            if (expected_output_temp === (expected_output_temp ^ output_temp ^ expected_output_temp)) begin
                $display("PASS");
                $display("  Outputs: output_temp=%h",
                         output_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_temp=%h",
                         expected_output_temp);
                $display("  Got:      output_temp=%h",
                         output_temp);
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
        $dumpvars(0,cal_factor, clk, input_temp, output_temp);
    end

endmodule
