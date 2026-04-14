`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] cal_val;
    reg [9:0] temp_in;
    wire [9:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .cal_val(cal_val),
        .temp_in(temp_in),
        .temp_out(temp_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition", test_num);
            temp_in = 10'd100;
            cal_val = 10'd50;
            #1;

            check_outputs(10'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Calibration", test_num);
            temp_in = 10'd255;
            cal_val = 10'd0;
            #1;

            check_outputs(10'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            temp_in = 10'd0;
            cal_val = 10'd123;
            #1;

            check_outputs(10'd123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrap Around (Boundary)", test_num);
            temp_in = 10'h3FF;
            cal_val = 10'h001;

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Wrap Around", test_num);
            temp_in = 10'd800;
            cal_val = 10'd400;

            #1;


            check_outputs(10'd176);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Both Maximum Values", test_num);
            temp_in = 10'h3FF;
            cal_val = 10'h3FF;

            #1;


            check_outputs(10'h3FE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Addition", test_num);
            temp_in = 10'h200;
            cal_val = 10'h100;
            #1;

            check_outputs(10'h300);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            temp_in = 10'b1010101010;
            cal_val = 10'b0101010101;

            #1;


            check_outputs(10'b1111111111);
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
        input [9:0] expected_temp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: temp_out=%h",
                         temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_out=%h",
                         expected_temp_out);
                $display("  Got:      temp_out=%h",
                         temp_out);
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

endmodule
