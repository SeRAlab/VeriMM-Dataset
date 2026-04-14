`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adc_input;
    reg clk;
    reg reset;
    reg [15:0] threshold;
    wire adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .reset(reset),
        .threshold(threshold),
        .adc_output(adc_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adc_input = 0;
            threshold = 0;
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
            $display("Testcase %0d: Input less than threshold", test_num);
            reset_dut();
            threshold = 16'h1000;
            adc_input = 16'h0500;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input greater than threshold", test_num);
            reset_dut();
            threshold = 16'h1000;
            adc_input = 16'h2000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input equal to threshold", test_num);
            reset_dut();
            threshold = 16'h5555;
            adc_input = 16'h5555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values (Input > Threshold)", test_num);
            reset_dut();
            threshold = 16'hFFFE;
            adc_input = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero threshold and zero input", test_num);
            reset_dut();
            threshold = 16'h0000;
            adc_input = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High input, Low threshold", test_num);
            reset_dut();
            threshold = 16'h0001;
            adc_input = 16'h8000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential update check", test_num);
            reset_dut();


            threshold = 16'h1000;
            adc_input = 16'h2000;
            @(posedge clk);


            #1;
            adc_input = 16'h0100;
            @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset priority", test_num);
            reset_dut();
            threshold = 16'h0001;
            adc_input = 16'hFFFF;
            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
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
        $display("adc_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_adc_output;
        begin
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%b",
                         adc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%b",
                         expected_adc_output);
                $display("  Got:      adc_output=%b",
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
        $dumpvars(0,adc_input, clk, reset, threshold, adc_output);
    end

endmodule
