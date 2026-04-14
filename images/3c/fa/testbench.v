`timescale 1ns/1ps

module adc_24bit_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] analog_input;
    reg clk;
    reg reset;
    wire [23:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24bit dut (
        .analog_input(analog_input),
        .clk(clk),
        .reset(reset),
        .digital_output(digital_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            analog_input = 0;
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
            reset_dut();
            analog_input = 24'h000000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Zero Input", test_num);
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            analog_input = 24'hFFFFFF;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Full Scale Input", test_num);
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            analog_input = 24'hAAAAAA;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Mid-range Alternating Pattern (A)", test_num);
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            analog_input = 24'h555555;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Mid-range Alternating Pattern (5)", test_num);
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            analog_input = 24'h800000;
            @(posedge clk);
            #1;
            $display("Test Case %0d: MSB Set", test_num);
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            analog_input = 24'h123456;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Random Hex Pattern", test_num);
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            analog_input = 24'hABCDEF;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Reset Priority Check", test_num);
            #1;

            check_outputs(24'h000000);
            reset = 0;
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
        input [23:0] expected_digital_output;
        begin
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
        $dumpvars(0,analog_input, clk, reset, digital_output);
    end

endmodule
