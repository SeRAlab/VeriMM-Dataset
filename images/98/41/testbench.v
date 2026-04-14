`timescale 1ns/1ps

module binary_left_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [1:0] shift_amount;
    wire [3:0] shifted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_left_shifter dut (
        .a(a),
        .shift_amount(shift_amount),
        .shifted(shifted)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'b1011;
            shift_amount = 2'd0;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'b0001;
            shift_amount = 2'd1;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'b0011;
            shift_amount = 2'd2;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'b0001;
            shift_amount = 2'd3;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'b1111;
            shift_amount = 2'd1;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'b1010;
            shift_amount = 2'd2;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'b1000;
            shift_amount = 2'd1;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'b0000;
            shift_amount = 2'd3;
            $display("Test Case %0d: a=%b, shift_amount=%d", test_num, a, shift_amount);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_left_shifter Testbench");
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
        input [3:0] expected_shifted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted === (expected_shifted ^ shifted ^ expected_shifted)) begin
                $display("PASS");
                $display("  Outputs: shifted=%h",
                         shifted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted=%h",
                         expected_shifted);
                $display("  Got:      shifted=%h",
                         shifted);
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
