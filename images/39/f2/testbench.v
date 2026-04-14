`timescale 1ns/1ps

module ADC_Converter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_in;
    wire [15:0] decimal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_Converter dut (
        .binary_in(binary_in),
        .decimal_out(decimal_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0 (Minimum)", test_num);
            binary_in = 16'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 65535 (Maximum)", test_num);
            binary_in = 16'd65535;
            #1;

            check_outputs(16'd65535);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1 (Smallest Non-Zero)", test_num);
            binary_in = 16'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 32768 (Mid-point/MSB set)", test_num);
            binary_in = 16'd32768;
            #1;

            check_outputs(16'd32768);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 12345 (Standard value)", test_num);
            binary_in = 16'd12345;
            #1;

            check_outputs(16'd12345);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 54321 (Large value)", test_num);
            binary_in = 16'd54321;
            #1;

            check_outputs(16'd54321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 255 (Byte boundary)", test_num);
            binary_in = 16'd255;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 43690 (Alternating Bits 1010...)", test_num);
            binary_in = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 21845 (Alternating Bits 0101...)", test_num);
            binary_in = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 4096 (Power of 2)", test_num);
            binary_in = 16'd4096;
            #1;

            check_outputs(16'd4096);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_Converter Testbench");
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
        input [15:0] expected_decimal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_out === (expected_decimal_out ^ decimal_out ^ expected_decimal_out)) begin
                $display("PASS");
                $display("  Outputs: decimal_out=%h",
                         decimal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_out=%h",
                         expected_decimal_out);
                $display("  Got:      decimal_out=%h",
                         decimal_out);
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

endmodule
