`timescale 1ns/1ps

module bin_to_bcd_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [3:0] ones;
    wire [2:0] tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_bcd dut (
        .binary(binary),
        .ones(ones),
        .tens(tens)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            binary = 4'd0;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            binary = 4'd5;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd5, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            binary = 4'd9;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd9, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            binary = 4'd10;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd0, 3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            binary = 4'd13;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd3, 3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            binary = 4'd15;
            $display("Test Case %0d: Binary Input = %d", test_num, binary);
            #1;

            check_outputs(4'd5, 3'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_bcd Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_ones;
        input [2:0] expected_tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens)) begin
                $display("PASS");
                $display("  Outputs: ones=%h, tens=%h",
                         ones, tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones=%h, tens=%h",
                         expected_ones, expected_tens);
                $display("  Got:      ones=%h, tens=%h",
                         ones, tens);
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
