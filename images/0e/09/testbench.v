`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_input;
    wire [9:0] decimal_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .binary_input(binary_input),
        .decimal_output(decimal_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 0 (Minimum Value)", test_num);
        binary_input = 8'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 1", test_num);
        binary_input = 8'd1;
        #1;

        check_outputs(10'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 15", test_num);
        binary_input = 8'd15;
        #1;

        check_outputs(10'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 64", test_num);
        binary_input = 8'd64;
        #1;

        check_outputs(10'd64);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 127 (Mid-point Lower)", test_num);
        binary_input = 8'd127;
        #1;

        check_outputs(10'd127);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 128 (Mid-point Upper)", test_num);
        binary_input = 8'd128;
        #1;

        check_outputs(10'd128);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 170 (Alternating Bits 10101010)", test_num);
        binary_input = 8'b10101010;
        #1;

        check_outputs(10'd170);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 85 (Alternating Bits 01010101)", test_num);
        binary_input = 8'b01010101;
        #1;

        check_outputs(10'd85);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 200", test_num);
        binary_input = 8'd200;
        #1;

        check_outputs(10'd200);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 255 (Maximum Value)", test_num);
        binary_input = 8'd255;
        #1;

        check_outputs(10'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [9:0] expected_decimal_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_output === (expected_decimal_output ^ decimal_output ^ expected_decimal_output)) begin
                $display("PASS");
                $display("  Outputs: decimal_output=%h",
                         decimal_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_output=%h",
                         expected_decimal_output);
                $display("  Got:      decimal_output=%h",
                         decimal_output);
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
