`timescale 1ns/1ps

module jpeg_quantizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dct_coeff;
    wire [3:0] quantized_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_quantizer dut (
        .dct_coeff(dct_coeff),
        .quantized_value(quantized_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum boundary (0)", test_num);
            dct_coeff = 8'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower range check (15)", test_num);
            dct_coeff = 8'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition point (16)", test_num);
            dct_coeff = 8'd16;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (128)", test_num);
            dct_coeff = 8'd128;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper range value (200)", test_num);
            dct_coeff = 8'd200;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near maximum boundary (240)", test_num);
            dct_coeff = 8'd240;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Absolute maximum (255)", test_num);
            dct_coeff = 8'd255;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary pattern (85)", test_num);
            dct_coeff = 8'b01010101;
            #1;

            check_outputs(4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_quantizer Testbench");
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
        input [3:0] expected_quantized_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quantized_value === (expected_quantized_value ^ quantized_value ^ expected_quantized_value)) begin
                $display("PASS");
                $display("  Outputs: quantized_value=%h",
                         quantized_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quantized_value=%h",
                         expected_quantized_value);
                $display("  Got:      quantized_value=%h",
                         quantized_value);
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
