`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [1:0] temp;
    wire [1:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .temp(temp),
        .fan_speed(fan_speed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            temp = 2'b00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 00, Enable 1 (Expecting Low speed 00)", test_num);
            reset_dut();
            enable = 1;
            temp = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 01, Enable 1 (Expecting Medium speed 01)", test_num);
            reset_dut();
            enable = 1;
            temp = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 10, Enable 1 (Expecting High speed 10)", test_num);
            reset_dut();
            enable = 1;
            temp = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 11, Enable 1 (Expecting High speed 10)", test_num);
            reset_dut();
            enable = 1;
            temp = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 01, Enable 0 (Expecting Low speed 00 due to disable)", test_num);
            reset_dut();
            enable = 0;
            temp = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp 11, Enable 0 (Expecting Low speed 00 due to disable)", test_num);
            reset_dut();
            enable = 0;
            temp = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Enable 0 to Enable 1 at Temp 10", test_num);
            reset_dut();
            enable = 0;
            temp = 2'b10;
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            #1 #1;
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
        $display("fan_speed_control Testbench");
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
        input [1:0] expected_fan_speed;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
        $dumpvars(0,clk, enable, reset, temp, fan_speed);
    end

endmodule
