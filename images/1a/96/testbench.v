`timescale 1ns/1ps

module temp_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] temperature;
    wire [2:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_controller dut (
        .clk(clk),
        .rst(rst),
        .temperature(temperature),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        temperature = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying reset state (Output should be LOW/000)", test_num);

        #1;


        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Low Temperature Boundary (0°C)", test_num);
        temperature = 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Low Temperature Boundary (5°C)", test_num);
        temperature = 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Normal Temperature Boundary (6°C)", test_num);
        temperature = 4'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Normal Temperature Mid-range (8°C)", test_num);
        temperature = 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Normal Temperature Boundary (10°C)", test_num);
        temperature = 4'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: High Temperature Boundary (11°C)", test_num);
        temperature = 4'd11;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: High Temperature Maximum (15°C)", test_num);
        temperature = 4'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Reset activation while at High temperature", test_num);
        temperature = 4'd14;
        @(posedge clk);
        #1;

        if (status == 3'b010) begin
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
            rst = 0;
        end else begin
            $display("Pre-condition failed");
            fail_count = fail_count + 1;
        end
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
        testcase008();
        testcase009();
        
        
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
        input [2:0] expected_status;
        begin
            if (expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: status=%h",
                         status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status=%h",
                         expected_status);
                $display("  Got:      status=%h",
                         status);
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
        $dumpvars(0,clk, rst, temperature, status);
    end

endmodule
