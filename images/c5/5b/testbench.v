`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .shift(shift),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: No Shift (data_in=1011, shift=00)");
            data_in = 4'b1011;
            shift = 2'b00;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Shift Left 1 (data_in=1011, shift=01)");
            data_in = 4'b1011;
            shift = 2'b01;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Shift Right 1 (data_in=1011, shift=10)");
            data_in = 4'b1011;
            shift = 2'b10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Shift Right 2 (data_in=1011, shift=11)");
            data_in = 4'b1011;
            shift = 2'b11;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Shift Left 1, MSB is lost (data_in=1111, shift=01)");
            data_in = 4'b1111;
            shift = 2'b01;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Shift Right 2 (data_in=1100, shift=11)");
            data_in = 4'b1100;
            shift = 2'b11;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Shift Right 1, LSB is lost (data_in=0001, shift=10)");
            data_in = 4'b0001;
            shift = 2'b10;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Zero input, any shift");
            data_in = 4'b0000;
            shift = 2'b01;
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
