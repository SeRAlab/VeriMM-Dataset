`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vdesired;
    reg [7:0] Vin;
    reg clk;
    reg reset;
    wire PWM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .Vdesired(Vdesired),
        .Vin(Vin),
        .clk(clk),
        .reset(reset),
        .PWM_out(PWM_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Vdesired = 0;
            Vin = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset = 1;
            Vin = 8'd255;
            Vdesired = 8'd128;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Vdesired = 0V (0%% Duty Cycle)", test_num);
            Vin = 8'd255;
            Vdesired = 8'd0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Vdesired = Vin (100%% Duty Cycle)", test_num);
            Vin = 8'd128;
            Vdesired = 8'd128;
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Saturation check (Vdesired > Vin)", test_num);
            Vin = 8'd100;
            Vdesired = 8'd200;
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Intermediate regulation start check (Duty > 0)", test_num);
            Vin = 8'd255;
            Vdesired = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_PWM_out;
        begin
            if (expected_PWM_out === (expected_PWM_out ^ PWM_out ^ expected_PWM_out)) begin
                $display("PASS");
                $display("  Outputs: PWM_out=%b",
                         PWM_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM_out=%b",
                         expected_PWM_out);
                $display("  Got:      PWM_out=%b",
                         PWM_out);
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
        $dumpvars(0,Vdesired, Vin, clk, reset, PWM_out);
    end

endmodule
