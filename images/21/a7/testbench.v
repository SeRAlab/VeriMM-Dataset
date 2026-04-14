`timescale 1ns/1ps

module ADC_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] adc_data;
    reg clk;
    reg reset;
    wire [23:0] stored_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_Controller dut (
        .adc_data(adc_data),
        .clk(clk),
        .reset(reset),
        .stored_data(stored_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adc_data = 24'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Data Sampling", test_num);
            reset_dut();
            adc_data = 24'hABCDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Data Updates", test_num);
            reset_dut();
            adc_data = 24'h111111;
            @(posedge clk);
            #1;
            adc_data = 24'h222222;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h222222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value (All Ones)", test_num);
            reset_dut();
            adc_data = 24'hFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value (All Zeros Sampling)", test_num);
            reset_dut();
            adc_data = 24'hFFFFFF;
            @(posedge clk);
            #1;
            adc_data = 24'h000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset During Operation", test_num);
            reset_dut();
            adc_data = 24'h555555;
            @(posedge clk);
            #1;
            reset = 1;
            #10;
            reset = 0;
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern Testing", test_num);
            reset_dut();
            adc_data = 24'hAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_Controller Testbench");
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
        input [23:0] expected_stored_data;
        begin
            if (expected_stored_data === (expected_stored_data ^ stored_data ^ expected_stored_data)) begin
                $display("PASS");
                $display("  Outputs: stored_data=%h",
                         stored_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_data=%h",
                         expected_stored_data);
                $display("  Got:      stored_data=%h",
                         stored_data);
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
        $dumpvars(0,adc_data, clk, reset, stored_data);
    end

endmodule
