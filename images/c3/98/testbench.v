`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg rotate_left;
    reg rotate_right;
    reg [1:0] shift;
    reg shift_left;
    reg shift_right;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right),
        .shift(shift),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 4'b1011;
            shift = 2'd0;
            shift_left = 1; shift_right = 0; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'b1011;
            shift = 2'd1;
            shift_left = 1; shift_right = 0; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'b1011;
            shift = 2'd2;
            shift_left = 1; shift_right = 0; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'b1011;
            shift = 2'd3;
            shift_left = 1; shift_right = 0; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'b1101;
            shift = 2'd0;
            shift_left = 0; shift_right = 1; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'b1101;
            shift = 2'd1;
            shift_left = 0; shift_right = 1; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 4'b1101;
            shift = 2'd2;
            shift_left = 0; shift_right = 1; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 4'b1101;
            shift = 2'd3;
            shift_left = 0; shift_right = 1; rotate_left = 0; rotate_right = 0;
            $display("Test %0d: Shift Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = 4'b1001;
            shift = 2'd0;
            shift_left = 0; shift_right = 0; rotate_left = 1; rotate_right = 0;
            $display("Test %0d: Rotate Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 4'b1001;
            shift = 2'd1;
            shift_left = 0; shift_right = 0; rotate_left = 1; rotate_right = 0;
            $display("Test %0d: Rotate Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data = 4'b1001;
            shift = 2'd2;
            shift_left = 0; shift_right = 0; rotate_left = 1; rotate_right = 0;
            $display("Test %0d: Rotate Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data = 4'b1001;
            shift = 2'd3;
            shift_left = 0; shift_right = 0; rotate_left = 1; rotate_right = 0;
            $display("Test %0d: Rotate Left - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            data = 4'b0111;
            shift = 2'd0;
            shift_left = 0; shift_right = 0; rotate_left = 0; rotate_right = 1;
            $display("Test %0d: Rotate Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            data = 4'b0111;
            shift = 2'd1;
            shift_left = 0; shift_right = 0; rotate_left = 0; rotate_right = 1;
            $display("Test %0d: Rotate Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            data = 4'b0111;
            shift = 2'd2;
            shift_left = 0; shift_right = 0; rotate_left = 0; rotate_right = 1;
            $display("Test %0d: Rotate Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            data = 4'b0111;
            shift = 2'd3;
            shift_left = 0; shift_right = 0; rotate_left = 0; rotate_right = 1;
            $display("Test %0d: Rotate Right - Data: %b, Shift: %0d", test_num, data, shift);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
