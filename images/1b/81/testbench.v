`timescale 1ns/1ps

module ADC_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] analog_input;
    reg clk;
    reg enable;
    wire [3:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_16bit dut (
        .analog_input(analog_input),
        .clk(clk),
        .enable(enable),
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
            enable <= 0;
            analog_input <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: MSB extraction of 16'hA5A5", test_num);
            enable <= 1;
            analog_input <= 16'hA5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: MSB extraction of 16'h7000", test_num);
            enable <= 1;
            analog_input <= 16'h7000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: MSB extraction of 16'hFFFF", test_num);
            enable <= 1;
            analog_input <= 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: MSB extraction of 16'h0FFF", test_num);
            enable <= 1;
            analog_input <= 16'h0FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low test (Should maintain previous value)", test_num);


            enable <= 1;
            analog_input <= 16'hC000;
            @(posedge clk);
            #2;


            enable <= 0;
            analog_input <= 16'hE000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential updates", test_num);

            enable <= 1;
            analog_input <= 16'h1234;
            @(posedge clk);

            analog_input <= 16'h5678;
            @(posedge clk);

            analog_input <= 16'h9ABC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Extraction of 16'hB001", test_num);
            enable <= 1;
            analog_input <= 16'hB001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_16bit Testbench");
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
        $dumpvars(0,analog_input, clk, enable, digital_output);
    end

endmodule
