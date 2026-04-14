`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] adc_input;
    reg clk;
    reg rst;
    reg valid;
    wire [23:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .adc_output(adc_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            adc_input = 24'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic valid input pass-through", test_num);
            reset_dut();
            valid = 1;
            adc_input = 24'hABCDEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Latch behavior (valid 1 -> 0)", test_num);
            reset_dut();


            valid = 1;
            adc_input = 24'h123456;
            @(posedge clk);


            #1 valid = 0;
            adc_input = 24'hFFFFFF;
            @(posedge clk);

            #1;

            #1;


            check_outputs(24'h123456);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input change while valid is low", test_num);
            reset_dut();


            valid = 1;
            adc_input = 24'hAAAAAA;
            @(posedge clk);


            #1 valid = 0;
            adc_input = 24'h111111; @(posedge clk);
            adc_input = 24'h222222; @(posedge clk);
            adc_input = 24'h333333; @(posedge clk);

            #1 #1;
 check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Recovering from latch state", test_num);
            reset_dut();


            valid = 1;
            adc_input = 24'hBBBBBB;
            @(posedge clk);
            #1 valid = 0;
            adc_input = 24'h000000;
            @(posedge clk);


            #1 valid = 1;
            adc_input = 24'h555555;
            @(posedge clk);

            #1 #1;
 check_outputs(24'h555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset during active operation", test_num);
            reset_dut();

            valid = 1;
            adc_input = 24'h888888;
            @(posedge clk);


            #1 rst = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(24'h000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum 24-bit value check", test_num);
            reset_dut();

            valid = 1;
            adc_input = 24'hFFFFFF;
            @(posedge clk);

            #1 #1;
 check_outputs(24'hFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [23:0] expected_adc_output;
        begin
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h",
                         adc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h",
                         expected_adc_output);
                $display("  Got:      adc_output=%h",
                         adc_output);
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
        $dumpvars(0,adc_input, clk, rst, valid, adc_output);
    end

endmodule
