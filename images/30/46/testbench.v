`timescale 1ns/1ps

module switching_regulator_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vfb;
    reg [7:0] Vin;
    reg [7:0] Vtarget;
    reg clk;
    reg rst;
    wire [7:0] duty_cycle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator_controller dut (
        .Vfb(Vfb),
        .Vin(Vin),
        .Vtarget(Vtarget),
        .clk(clk),
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
        Vfb = 8'd0;
        Vin = 8'd100;
        Vtarget = 8'd0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Reset State");
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Duty Cycle Increment (Vfb < Vtarget)");
        reset_dut();
        Vtarget = 8'd100;
        Vfb = 8'd50;
        Vin = 8'd200;

        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Duty Cycle Decrement (Vfb > Vtarget)");
        reset_dut();

        Vtarget = 8'd100;
        Vfb = 8'd50;
        repeat(20) @(posedge clk);

        Vfb = 8'd150;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Steady State (Vfb == Vtarget)");
        reset_dut();
        Vtarget = 8'd100;
        Vfb = 8'd50;
        repeat(10) @(posedge clk);

        Vfb = 8'd100;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Lower Saturation (Min 0)");
        reset_dut();
        Vtarget = 8'd50;
        Vfb = 8'd100;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Upper Saturation (Max 255)");
        reset_dut();
        Vtarget = 8'd200;
        Vfb = 8'd0;
        repeat(300) @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator_controller Testbench");
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
        $dumpvars(0,Vfb, Vin, Vtarget, clk, rst, duty_cycle);
    end

endmodule
