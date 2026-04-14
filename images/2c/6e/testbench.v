`timescale 1ns/1ps

module dac_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_16bit dut (
        .data_in(data_in),
        .analog_out(analog_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Value (0x0000)", test_num);
            data_in = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Value (0xFFFF)", test_num);
            data_in = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Midpoint (0x8000)", test_num);
            data_in = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits AAAA", test_num);
            data_in = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 5555", test_num);
            data_in = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern 1234", test_num);
            data_in = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Pattern ABCD", test_num);
            data_in = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit High (Bit 7)", test_num);
            data_in = 16'h0080;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime-like pattern 7F7F", test_num);
            data_in = 16'h7F7F;
            #1;

            check_outputs(16'h7F7F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (0x0001)", test_num);
            data_in = 16'h0001;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_16bit Testbench");
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
        input [15:0] expected_analog_out;
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
