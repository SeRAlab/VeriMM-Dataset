`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] gain;
    reg [15:0] input_data;
    wire [19:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .gain(gain),
        .input_data(input_data),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0000 (x1), Input 0x0001", test_num);
            gain = 4'b0000;
            input_data = 16'h0001;
            #1;

            check_outputs(20'h00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0000 (x1), Input 0xFFFF", test_num);
            gain = 4'b0000;
            input_data = 16'hFFFF;
            #1;

            check_outputs(20'h0FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0001 (x2), Input 0x1234", test_num);
            gain = 4'b0001;
            input_data = 16'h1234;
            #1;

            check_outputs(20'h02468);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0010 (x4), Input 0x1000", test_num);
            gain = 4'b0010;
            input_data = 16'h1000;
            #1;

            check_outputs(20'h04000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0011 (x8), Input 0x0500", test_num);
            gain = 4'b0011;
            input_data = 16'h0500;
            #1;

            check_outputs(20'h02800);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0100 (x16), Input 0x8000", test_num);
            gain = 4'b0100;
            input_data = 16'h8000;
            #1;

            check_outputs(20'h80000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0101 (x32), Input 0x7FFF", test_num);
            gain = 4'b0101;
            input_data = 16'h7FFF;
            #1;

            check_outputs(20'hFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0110 (Invalid > 5), Input 0x1234", test_num);
            gain = 4'b0110;
            input_data = 16'h1234;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 1111 (Invalid > 5), Input 0xFFFF", test_num);
            gain = 4'b1111;
            input_data = 16'hFFFF;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gain 0101 (x32), Input 0x0000", test_num);
            gain = 4'b0101;
            input_data = 16'h0000;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
        input [19:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
