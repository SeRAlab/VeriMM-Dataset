`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adc_input;
    reg clk;
    reg reset;
    wire [3:0] msb_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .clk(clk),
        .reset(reset),
        .msb_output(msb_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adc_input = 16'h0000;
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
            $display("Running Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Maximum Input (0xFFFF)", test_num);
            reset_dut();
            adc_input = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 0x1000", test_num);
            reset_dut();
            adc_input = 16'h1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 0xA5A5", test_num);
            reset_dut();
            adc_input = 16'hA5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 0x0FFF", test_num);
            reset_dut();
            adc_input = 16'h0FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 0x5555", test_num);
            reset_dut();
            adc_input = 16'h5555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input change between clocks", test_num);
            reset_dut();
            adc_input = 16'h2222;
            @(posedge clk);
            #2;

            adc_input = 16'hEEEE;
            #2;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input 0xBCDE", test_num);
            reset_dut();
            adc_input = 16'hBCDE;
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
        input [3:0] expected_msb_output;
        begin
            if (expected_msb_output === (expected_msb_output ^ msb_output ^ expected_msb_output)) begin
                $display("PASS");
                $display("  Outputs: msb_output=%h",
                         msb_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: msb_output=%h",
                         expected_msb_output);
                $display("  Got:      msb_output=%h",
                         msb_output);
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
        $dumpvars(0,adc_input, clk, reset, msb_output);
    end

endmodule
