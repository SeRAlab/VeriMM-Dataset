`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adc_input;
    reg clk;
    wire [11:0] dac_output;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .dac_output(dac_output),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            adc_input = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Value", test_num);
            reset_dut();
            adc_input = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Value", test_num);
            reset_dut();
            adc_input = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Value", test_num);
            reset_dut();
            adc_input = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h800, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LSB Truncation Check", test_num);
            reset_dut();
            adc_input = 16'h123F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h123, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern Test (AAAA)", test_num);
            reset_dut();
            adc_input = 16'hAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hAAA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern Test (BEEF)", test_num);
            reset_dut();
            adc_input = 16'hBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hBEE, 1'b1);
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
        input [11:0] expected_dac_output;
        input expected_valid_output;
        begin
            if (expected_dac_output === (expected_dac_output ^ dac_output ^ expected_dac_output) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: dac_output=%h, valid_output=%b",
                         dac_output, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_output=%h, valid_output=%b",
                         expected_dac_output, expected_valid_output);
                $display("  Got:      dac_output=%h, valid_output=%b",
                         dac_output, valid_output);
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
        $dumpvars(0,adc_input, clk, dac_output, valid_output);
    end

endmodule
