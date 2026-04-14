`timescale 1ns/1ps

module fan_speed_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] temperature;
    wire [1:0] speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_controller dut (
        .clk(clk),
        .temperature(temperature),
        .speed(speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        temperature = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Temperature = 15 (Below 20)", test_num);
        temperature = 8'd15;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Temperature = 19 (Below 20 edge)", test_num);
        temperature = 8'd19;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Temperature = 20 (Boundary Medium)", test_num);
        temperature = 8'd20;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Temperature = 25 (Mid-range Medium)", test_num);
        temperature = 8'd25;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Temperature = 30 (Boundary Medium)", test_num);
        temperature = 8'd30;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Temperature = 31 (Just above 30)", test_num);
        temperature = 8'd31;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Temperature = 100 (High range)", test_num);
        temperature = 8'd100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_controller Testbench");
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
        input [1:0] expected_speed;
        begin
            if (expected_speed === (expected_speed ^ speed ^ expected_speed)) begin
                $display("PASS");
                $display("  Outputs: speed=%h",
                         speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speed=%h",
                         expected_speed);
                $display("  Got:      speed=%h",
                         speed);
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
        $dumpvars(0,clk, temperature, speed);
    end

endmodule
