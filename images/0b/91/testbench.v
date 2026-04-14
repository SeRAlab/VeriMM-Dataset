`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_signal;
    reg [7:0] scale_factor;
    reg [7:0] threshold;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .in_signal(in_signal),
        .scale_factor(scale_factor),
        .threshold(threshold),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in_signal = 8'd25;
            threshold = 8'd50;
            scale_factor = 8'd128;
            $display("Testcase %0d: Input (25) < Threshold (50). Expected: 25", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in_signal = 8'd50;
            threshold = 8'd50;
            scale_factor = 8'd128;
            $display("Testcase %0d: Input (50) == Threshold (50). Expected: 50", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in_signal = 8'd100;
            threshold = 8'd50;
            scale_factor = 8'd128;
            $display("Testcase %0d: Input (100) > Threshold (50), Scale 0.5. Expected: 50", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in_signal = 8'd80;
            threshold = 8'd40;
            scale_factor = 8'd64;
            $display("Testcase %0d: Input (80) > Threshold (40), Scale 0.25. Expected: 20", test_num);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in_signal = -8'd50;
            threshold = 8'd20;
            scale_factor = 8'd128;
            $display("Testcase %0d: Input (-50) < Threshold (20). Expected: -50 (hCE)", test_num);
            #1;

            check_outputs(8'hCE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in_signal = 8'd120;
            threshold = 8'd10;
            scale_factor = 8'd255;
            $display("Testcase %0d: Input (120) > Threshold (10), Scale 0.99. Expected: 119", test_num);
            #1;

            check_outputs(8'd119);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in_signal = 8'd127;
            threshold = 8'd0;
            scale_factor = 8'd128;
            $display("Testcase %0d: Input (127) > Threshold (0), Scale 0.5. Expected: 63", test_num);
            #1;

            check_outputs(8'd63);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in_signal = 8'd100;
            threshold = 8'd20;
            scale_factor = 8'd0;
            $display("Testcase %0d: Input (100) > Threshold (20), Scale 0. Expected: 0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        input [7:0] expected_out_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
