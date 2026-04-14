`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] adc_input;
    reg clk;
    reg reset;
    reg start;
    wire [23:0] adc_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .reset(reset),
        .start(start),
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
            $display("\nResetting DUT...");
            reset = 1;
            start = 0;
            adc_input = 24'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Latch Operation", test_num);
            reset_dut();

            adc_input = 24'hABCDEF;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            adc_input = 24'h000000;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'hABCDEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Data Retention", test_num);
            reset_dut();


            adc_input = 24'h123456;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            repeat(2) @(posedge clk);
            adc_input = 24'hFFFFFF;
            repeat(2) @(posedge clk);
            adc_input = 24'h555555;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(24'h123456, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Consecutive Captures", test_num);
            reset_dut();


            adc_input = 24'hAAAAAA;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            repeat(2) @(posedge clk);


            adc_input = 24'hBBBBBB;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(24'hBBBBBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            adc_input = 24'h55AA55;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(24'h000000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Value Capture", test_num);
            reset_dut();


            adc_input = 24'hFFFFFF;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            repeat(2) @(posedge clk);


            adc_input = 24'h000000;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(24'h000000, 1'b1);
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
        $dumpvars(0,adc_input, clk, reset, start, adc_output, valid);
    end

endmodule
