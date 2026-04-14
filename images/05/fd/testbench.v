`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift_dir;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: No Shift (shift_dir=00)");
            data_in = 4'b1101;
            shift_dir = 2'b00;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Left Shift by 1 (shift_dir=01)");
            data_in = 4'b1011;
            shift_dir = 2'b01;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Left Shift by 2 (shift_dir=10)");
            data_in = 4'b1011;
            shift_dir = 2'b10;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Right Shift by 1 (shift_dir=11)");
            data_in = 4'b1101;
            shift_dir = 2'b11;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Left Shift by 1 with zero input (shift_dir=01)");
            data_in = 4'b0000;
            shift_dir = 2'b01;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Left Shift by 2 - All ones (shift_dir=10)");
            data_in = 4'b1111;
            shift_dir = 2'b10;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Right Shift by 1 - LSB drops (shift_dir=11)");
            data_in = 4'b0001;
            shift_dir = 2'b11;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: No Shift - Alt data (shift_dir=00)");
            data_in = 4'b1010;
            shift_dir = 2'b00;
            #1;

            check_outputs(4'b1010);
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
        input [3:0] expected_data_out;
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
