`timescale 1ns/1ps

module adc_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] analog_input;
    reg clk;
    wire [3:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16bit dut (
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
            analog_input = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: Minimum Input 0x0000", test_num);
            analog_input = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: Maximum Input 0xFFFF", test_num);
            analog_input = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: Boundary Input 0x0FFF", test_num);
            analog_input = 16'h0FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: Boundary Input 0x1000", test_num);
            analog_input = 16'h1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: Mid-point Input 0x8000", test_num);
            analog_input = 16'h8000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: Input 0x7ABC", test_num);
            analog_input = 16'h7ABC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test Case %0d: Input 0xC555", test_num);
            analog_input = 16'hC555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test Case %0d: Transition from 0x3FFF to 0x4000", test_num);
            analog_input = 16'h3FFF;
            @(posedge clk);
            #2;

            if (digital_output !== 4'h3) $display("Intermediate fail at 0x3FFF");

            analog_input = 16'h4000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            $display("Test Case %0d: High Boundary Input 0xEFFF", test_num);
            analog_input = 16'hEFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            $display("Test Case %0d: Pattern Input 0xA5A5", test_num);
            analog_input = 16'hA5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16bit Testbench");
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
        testcase010();
        
        
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
        input [3:0] expected_digital_output;
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
