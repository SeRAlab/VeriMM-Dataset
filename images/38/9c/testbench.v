`timescale 1ns/1ps

module adc_24_to_10_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] analog_input;
    reg clk;
    wire [9:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24_to_10 dut (
        .analog_input(analog_input),
        .clk(clk),
        .digital_output(digital_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            analog_input = 24'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            analog_input = 24'h000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            analog_input = 24'hFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint (MSB set)", test_num);
            analog_input = 24'h800000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Value A (0x123456)", test_num);


            analog_input = 24'h123456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h048);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Value B (0xABCDEF)", test_num);


            analog_input = 24'hABCDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h2AF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Check (Truncation)", test_num);


            analog_input = 24'h003FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Updates", test_num);

            analog_input = 24'h555555;
            @(posedge clk);
            #2;

            analog_input = 24'hAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24_to_10 Testbench");
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
        input [9:0] expected_digital_output;
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
        $dumpvars(0,analog_input, clk, digital_output);
    end

endmodule
