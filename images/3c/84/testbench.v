`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in_signal;
    wire [4:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .in_signal(in_signal),
        .out_signal(out_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LSB Shift", test_num);
            in_signal = 5'b00001;
            #1;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Wrapping MSB to LSB", test_num);
            in_signal = 5'b10000;
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All bits set", test_num);
            in_signal = 5'b11111;
            #1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All bits clear", test_num);
            in_signal = 5'b00000;
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 10101", test_num);
            in_signal = 5'b10101;
            #1;
            #1;

            check_outputs(5'b01011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 01010", test_num);
            in_signal = 5'b01010;
            #1;
            #1;

            check_outputs(5'b10100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 11001", test_num);
            in_signal = 5'b11001;
            #1;
            #1;

            check_outputs(5'b10011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit in middle", test_num);
            in_signal = 5'b00100;
            #1;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [4:0] expected_out_signal;
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
