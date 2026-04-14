`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift_ctrl;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .shift_ctrl(shift_ctrl),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 4'b1011;
        shift_ctrl = 2'b00;
        $display("Test 001: No Shift (00) - Input: %b", data_in);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 4'b1011;
        shift_ctrl = 2'b01;
        $display("Test 002: Left Shift (01) - Input: %b", data_in);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 4'b1011;
        shift_ctrl = 2'b10;
        $display("Test 003: Right Shift (10) - Input: %b", data_in);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 4'b1011;
        shift_ctrl = 2'b11;
        $display("Test 004: Left Shift Wrap-around (11) - Input: %b", data_in);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 4'b1000;
        shift_ctrl = 2'b01;
        $display("Test 005: Left Shift (01) Overflow - Input: %b", data_in);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 4'b1000;
        shift_ctrl = 2'b11;
        $display("Test 006: Left Shift Wrap-around (11) MSB to LSB - Input: %b", data_in);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 4'b0001;
        shift_ctrl = 2'b10;
        $display("Test 007: Right Shift (10) LSB Discard - Input: %b", data_in);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 4'b1111;
        shift_ctrl = 2'b10;
        $display("Test 008: Right Shift (10) All Ones - Input: %b", data_in);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 4'b0110;
        shift_ctrl = 2'b11;
        $display("Test 009: Left Shift Wrap-around (11) Internal Bits - Input: %b", data_in);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 4'b0000;
        shift_ctrl = 2'b11;
        $display("Test 010: Wrap-around (11) All Zeros - Input: %b", data_in);
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
