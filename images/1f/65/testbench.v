`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg [2:0] shift_amount;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 5'b10101;
            shift_amount = 3'd0;
            $display("Testcase %0d: Zero shift (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 5'b10000;
            shift_amount = 3'd1;
            $display("Testcase %0d: Shift left by 1 (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 5'b10000;
            shift_amount = 3'd2;
            $display("Testcase %0d: Shift left by 2 (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 5'b00001;
            shift_amount = 3'd1;
            $display("Testcase %0d: Shift left by 1, bit 0 moves (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 5'b01100;
            shift_amount = 3'd2;
            $display("Testcase %0d: Shift left by 2, complex pattern (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 5'b11011;
            shift_amount = 3'd5;
            $display("Testcase %0d: Shift by bit-width (5) (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 5'b10110;
            shift_amount = 3'd6;
            $display("Testcase %0d: Shift by 6 (6 mod 5 = 1) (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b01101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 5'b10110;
            shift_amount = 3'd7;
            $display("Testcase %0d: Shift by 7 (7 mod 5 = 2) (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b11010);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 5'b11111;
            shift_amount = 3'd3;
            $display("Testcase %0d: All ones shift (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 5'b00000;
            shift_amount = 3'd4;
            $display("Testcase %0d: All zeros shift (data_in=%b, shift=%0d)", test_num, data_in, shift_amount);
            #1;

            check_outputs(5'b00000);
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
