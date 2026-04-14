`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [4:0] input_signal;
    reg reset;
    wire [4:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .enable(enable),
        .input_signal(input_signal),
        .reset(reset),
        .output_signal(output_signal)
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
            input_signal = 5'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Data Update (Enable=1)", test_num);
            reset_dut();
            input_signal = 5'h1A;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Enable Gating (Enable=0)", test_num);
            reset_dut();
            input_signal = 5'h0F;
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Hold Value (Enable 1 -> 0)", test_num);
            reset_dut();

            input_signal = 5'h05;
            enable = 1;
            @(posedge clk);
            #1;

            enable = 0;
            input_signal = 5'h1F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Full Width Test (5'h1F)", test_num);
            reset_dut();
            input_signal = 5'h1F;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset during Operation", test_num);
            reset_dut();
            input_signal = 5'h15;
            enable = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [4:0] expected_output_signal;
        begin
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
        $dumpvars(0,clk, enable, input_signal, reset, output_signal);
    end

endmodule
