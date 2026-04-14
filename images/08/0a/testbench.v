`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_factor;
    reg clk;
    reg [15:0] temp_input;
    wire [15:0] temp_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .temp_input(temp_input),
        .temp_output(temp_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            calibration_factor = 0;
            temp_input = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            reset_dut();
            temp_input = 16'h0000;
            calibration_factor = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition", test_num);
            reset_dut();
            temp_input = 16'h1000;
            calibration_factor = 8'h05;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max calibration factor", test_num);
            reset_dut();
            temp_input = 16'h0010;
            calibration_factor = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h010F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary overflow", test_num);
            reset_dut();
            temp_input = 16'hFFFF;
            calibration_factor = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random high values", test_num);
            reset_dut();
            temp_input = 16'hABCD;
            calibration_factor = 8'h12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hABDF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values", test_num);
            reset_dut();
            temp_input = 16'h7530;
            calibration_factor = 8'h64;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h7594);
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
        input [15:0] expected_temp_output;
        begin
            if (expected_temp_output === (expected_temp_output ^ temp_output ^ expected_temp_output)) begin
                $display("PASS");
                $display("  Outputs: temp_output=%h",
                         temp_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_output=%h",
                         expected_temp_output);
                $display("  Got:      temp_output=%h",
                         temp_output);
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
        $dumpvars(0,calibration_factor, clk, temp_input, temp_output);
    end

endmodule
