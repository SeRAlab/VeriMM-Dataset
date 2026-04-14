`timescale 1ns/1ps

module quantizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    wire [3:0] quantized_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quantizer dut (
        .pixel_value(pixel_value),
        .quantized_value(quantized_value)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input = 0 (Lower bound of Range 0)");
            pixel_value = 8'd0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input = 15 (Upper bound of Range 0)");
            pixel_value = 8'd15;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input = 16 (Lower bound of Range 1)");
            pixel_value = 8'd16;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input = 31 (Upper bound of Range 1)");
            pixel_value = 8'd31;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input = 64 (Start of Range 4)");
            pixel_value = 8'd64;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Input = 111 (End of Range 6)");
            pixel_value = 8'd111;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Input = 128 (Start of Range 8)");
            pixel_value = 8'd128;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Input = 175 (End of Range A)");
            pixel_value = 8'd175;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Input = 240 (Start of Range F)");
            pixel_value = 8'd240;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Input = 255 (Upper bound of Range F)");
            pixel_value = 8'd255;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quantizer Testbench");
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
