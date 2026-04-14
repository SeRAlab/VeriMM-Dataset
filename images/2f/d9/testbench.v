`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] desired_voltage;
    reg [7:0] measured_voltage;
    reg rst;
    wire [7:0] duty_cycle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .clk(clk),
        .desired_voltage(desired_voltage),
        .measured_voltage(measured_voltage),
        .rst(rst),
        .duty_cycle(duty_cycle)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            desired_voltage = 8'd0;
            measured_voltage = 8'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            desired_voltage = 8'd100;
            measured_voltage = 8'd50;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            desired_voltage = 8'd100;
            measured_voltage = 8'd0;
            repeat(20) @(posedge clk);

            desired_voltage = 8'd50;
            measured_voltage = 8'd150;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            desired_voltage = 8'd100;
            measured_voltage = 8'd50;
            repeat(10) @(posedge clk);

            desired_voltage = 8'd80;
            measured_voltage = 8'd80;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            desired_voltage = 8'd255;
            measured_voltage = 8'd0;
            repeat(300) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            desired_voltage = 8'd10;
            measured_voltage = 8'd0;
            repeat(10) @(posedge clk);

            desired_voltage = 8'd0;
            measured_voltage = 8'd255;
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator Testbench");
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
        input [7:0] expected_duty_cycle;
        begin
            if (expected_duty_cycle === (expected_duty_cycle ^ duty_cycle ^ expected_duty_cycle)) begin
                $display("PASS");
                $display("  Outputs: duty_cycle=%h",
                         duty_cycle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: duty_cycle=%h",
                         expected_duty_cycle);
                $display("  Got:      duty_cycle=%h",
                         duty_cycle);
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
        $dumpvars(0,clk, desired_voltage, measured_voltage, rst, duty_cycle);
    end

endmodule
