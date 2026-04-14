`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] digital_in;
    wire [7:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .digital_in(digital_in),
        .analog_out(analog_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Value (0)", test_num);
            digital_in = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Value (255)", test_num);
            digital_in = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint Value (128)", test_num);
            digital_in = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern 1 (170)", test_num);
            digital_in = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern 2 (85)", test_num);
            digital_in = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Range Value (1)", test_num);
            digital_in = 8'h01;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Range Value (254)", test_num);
            digital_in = 8'hFE;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Quarter Scale (64)", test_num);
            digital_in = 8'h40;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three-Quarter Scale (192)", test_num);
            digital_in = 8'hC0;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [7:0] expected_analog_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%h",
                         analog_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%h",
                         expected_analog_out);
                $display("  Got:      analog_out=%h",
                         analog_out);
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
