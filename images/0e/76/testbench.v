`timescale 1ns/1ps

module buck_converter_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    reg clk;
    reg rst;
    wire PWM_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    buck_converter dut (
        .Vin(Vin),
        .Vref(Vref),
        .clk(clk),
        .rst(rst),
        .PWM_out(PWM_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Vin = 8'h0;
            Vref = 8'h0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Vref = 0 (0%% Duty Cycle)");
            reset_dut();
            Vin = 8'd200;
            Vref = 8'd0;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Vref = Vin (100%% Duty Cycle)");
            reset_dut();
            Vin = 8'd150;
            Vref = 8'd150;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Vref > Vin (Saturation High)");
            reset_dut();
            Vin = 8'd100;
            Vref = 8'd200;
            repeat(50) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Reset Active Check");
            reset_dut();
            rst = 1;
            Vin = 8'd255;
            Vref = 8'd255;
            #20;
            #1;

            check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Low Duty Cycle Check (Vref=1)");
            reset_dut();
            Vin = 8'd255;
            Vref = 8'd1;


            repeat(256) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("buck_converter Testbench");
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
        $dumpvars(0,Vin, Vref, clk, rst, PWM_out);
    end

endmodule
