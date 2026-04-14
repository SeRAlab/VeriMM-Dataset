`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_array;
    wire [3:0] out_array;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .in_array(in_array),
        .out_array(out_array)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            in_array = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Ones");
            in_array = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Single One at MSB");
            in_array = 4'b1000;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Single One at LSB (Already Sorted)");
            in_array = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Mixed Bits (1010)");
            in_array = 4'b1010;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Mixed Bits (0101)");
            in_array = 4'b0101;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Reverse Sorted Two Ones");
            in_array = 4'b1100;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Three Ones (0111)");
            in_array = 4'b0111;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Three Ones (1011)");
            in_array = 4'b1011;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Three Ones (1110)");
            in_array = 4'b1110;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [3:0] expected_out_array;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_array === (expected_out_array ^ out_array ^ expected_out_array)) begin
                $display("PASS");
                $display("  Outputs: out_array=%h",
                         out_array);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_array=%h",
                         expected_out_array);
                $display("  Got:      out_array=%h",
                         out_array);
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
