`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] setpoint;
    reg [7:0] temp;
    wire cool;
    wire heat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .setpoint(setpoint),
        .temp(temp),
        .cool(cool),
        .heat(heat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temp = 0;
            setpoint = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp < Setpoint (Heating)", test_num);
            reset_dut();
            temp = 8'd20;
            setpoint = 8'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp > Setpoint (Cooling)", test_num);
            reset_dut();
            temp = 8'd30;
            setpoint = 8'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Temp == Setpoint (Idle)", test_num);
            reset_dut();
            temp = 8'd25;
            setpoint = 8'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Low (0, 0)", test_num);
            reset_dut();
            temp = 8'd0;
            setpoint = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary High (255, 255)", test_num);
            reset_dut();
            temp = 8'd255;
            setpoint = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extreme Cold (0 < 255)", test_num);
            reset_dut();
            temp = 8'd0;
            setpoint = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extreme Heat (255 > 0)", test_num);
            reset_dut();
            temp = 8'd255;
            setpoint = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small difference (24 < 25)", test_num);
            reset_dut();
            temp = 8'd24;
            setpoint = 8'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small difference (26 > 25)", test_num);
            reset_dut();
            temp = 8'd26;
            setpoint = 8'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_cool;
        input expected_heat;
        begin
            if (expected_cool === (expected_cool ^ cool ^ expected_cool) &&
                expected_heat === (expected_heat ^ heat ^ expected_heat)) begin
                $display("PASS");
                $display("  Outputs: cool=%b, heat=%b",
                         cool, heat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cool=%b, heat=%b",
                         expected_cool, expected_heat);
                $display("  Got:      cool=%b, heat=%b",
                         cool, heat);
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
        $dumpvars(0,clk, reset, setpoint, temp, cool, heat);
    end

endmodule
