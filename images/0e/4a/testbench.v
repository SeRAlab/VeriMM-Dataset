`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] coeff_a;
    reg [15:0] coeff_b;
    reg load_coeff;
    reg [15:0] raw_temp;
    reg reset;
    wire [15:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .clk(clk),
        .coeff_a(coeff_a),
        .coeff_b(coeff_b),
        .load_coeff(load_coeff),
        .raw_temp(raw_temp),
        .reset(reset),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load_coeff = 0;
            coeff_a = 0;
            coeff_b = 0;
            raw_temp = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Calibration (A=1, B=0)", test_num);
            reset_dut();

            coeff_a = 16'h0001;
            coeff_b = 16'h0000;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'h1234;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Offset Calibration (A=1, B=10)", test_num);
            reset_dut();

            coeff_a = 16'h0001;
            coeff_b = 16'h000A;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'h0064;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h006E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gain Calibration (A=2, B=0)", test_num);
            reset_dut();

            coeff_a = 16'h0002;
            coeff_b = 16'h0000;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'h0032;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0064);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gain and Offset (A=3, B=5)", test_num);
            reset_dut();

            coeff_a = 16'h0003;
            coeff_b = 16'h0005;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'h000A;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0023);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Gain (A=0, B=500)", test_num);
            reset_dut();

            coeff_a = 16'h0000;
            coeff_b = 16'h01F4;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h01F4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Handling", test_num);
            reset_dut();

            coeff_a = 16'h0008;
            coeff_b = 16'h0001;
            load_coeff = 1;
            @(posedge clk);
            load_coeff = 0;

            raw_temp = 16'h2000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0001);
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
        input [15:0] expected_calibrated_temp;
        begin
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h",
                         calibrated_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h",
                         expected_calibrated_temp);
                $display("  Got:      calibrated_temp=%h",
                         calibrated_temp);
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
        $dumpvars(0,clk, coeff_a, coeff_b, load_coeff, raw_temp, reset, calibrated_temp);
    end

endmodule
