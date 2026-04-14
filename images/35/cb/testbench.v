`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg reset;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .input_data(input_data),
        .reset(reset),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            reset = 0;
            input_data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Data Transfer");
            test_num = test_num + 1;
            reset_dut();
            input_data = 8'hA5;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Hold Value (Reset High)");
            test_num = test_num + 1;
            reset_dut();

            input_data = 8'h55;
            reset = 0;
            @(posedge clk);
            #1;

            input_data = 8'hFF;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: All Bits High (0xFF)");
            test_num = test_num + 1;
            reset_dut();
            input_data = 8'hFF;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: All Bits Low (0x00)");
            test_num = test_num + 1;
            reset_dut();

            input_data = 8'hAA;
            reset = 0;
            @(posedge clk);
            #1;

            input_data = 8'h00;
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive Transfers");
            test_num = test_num + 1;
            reset_dut();

            input_data = 8'h12;
            reset = 0;
            @(posedge clk);
            #1;

            input_data = 8'h34;
            reset = 0;
            @(posedge clk);
            #1;

            input_data = 8'h56;
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h56);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Recovery from Hold State");
            test_num = test_num + 1;
            reset_dut();


            input_data = 8'hCC;
            reset = 0;
            @(posedge clk);
            #1;


            input_data = 8'hDD;
            reset = 1;
            @(posedge clk);
            #1;


            input_data = 8'hEE;
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE);
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
        input [7:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, reset, output_data);
    end

endmodule
