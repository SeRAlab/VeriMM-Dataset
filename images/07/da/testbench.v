`timescale 1ns/1ps

module adc_24bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [11:0] sensor_input;
    wire [23:0] adc_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24bit dut (
        .clk(clk),
        .reset(reset),
        .sensor_input(sensor_input),
        .adc_output(adc_output),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        sensor_input = 0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Minimum Input (0x000)", test_num);
        reset_dut();
        sensor_input = 12'h000;


        wait(valid === 1);
        @(posedge clk);


        #1;



        check_outputs(24'h000000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Maximum Input (0xFFF)", test_num);
        reset_dut();
        sensor_input = 12'hFFF;

        wait(valid === 1);
        @(posedge clk);


        #1;



        check_outputs(24'hFFFFFF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Mid-Scale Input (0x800)", test_num);
        reset_dut();
        sensor_input = 12'h800;

        wait(valid === 1);
        @(posedge clk);


        #1;



        check_outputs(24'h800800, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Arbitrary Input (0xA5C)", test_num);
        reset_dut();
        sensor_input = 12'hA5C;

        wait(valid === 1);
        @(posedge clk);

        #1;


        check_outputs(24'hA5CA5C, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Arbitrary Input (0x5A3)", test_num);
        reset_dut();
        sensor_input = 12'h5A3;

        wait(valid === 1);
        @(posedge clk);

        #1;


        check_outputs(24'h5A35A3, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24bit Testbench");
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
        input [23:0] expected_adc_output;
        input expected_valid;
        begin
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h, valid=%b",
                         adc_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h, valid=%b",
                         expected_adc_output, expected_valid);
                $display("  Got:      adc_output=%h, valid=%b",
                         adc_output, valid);
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
        $dumpvars(0,clk, reset, sensor_input, adc_output, valid);
    end

endmodule
