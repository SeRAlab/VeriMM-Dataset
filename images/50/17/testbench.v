`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg [4:0] shift;
    reg shift_right;
    wire [31:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift(shift),
        .shift_right(shift_right),
        .shifted_data(shifted_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Left shift by 0", test_num);
        data = 32'h12345678;
        shift = 5'd0;
        shift_right = 1'b0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Left shift by 1", test_num);
        data = 32'h00000001;
        shift = 5'd1;
        shift_right = 1'b0;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Left shift by 16", test_num);
        data = 32'h0000FFFF;
        shift = 5'd16;
        shift_right = 1'b0;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Left shift by 31", test_num);
        data = 32'h00000001;
        shift = 5'd31;
        shift_right = 1'b0;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Right shift by 0", test_num);
        data = 32'h87654321;
        shift = 5'd0;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Right shift by 1", test_num);
        data = 32'h80000000;
        shift = 5'd1;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Right shift by 16", test_num);
        data = 32'hFFFF0000;
        shift = 5'd16;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Right shift by 31", test_num);
        data = 32'h80000000;
        shift = 5'd31;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Left shift boundary (31) with MSB set", test_num);
        data = 32'hFFFFFFFF;
        shift = 5'd31;
        shift_right = 1'b0;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Right shift boundary (31) with all bits set", test_num);
        data = 32'hFFFFFFFF;
        shift = 5'd31;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %03d: Shifting zero data", test_num);
        data = 32'h00000000;
        shift = 5'd15;
        shift_right = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %03d: Pattern shift (0xAAAAAAAA) left by 4", test_num);
        data = 32'hAAAAAAAA;
        shift = 5'd4;
        shift_right = 1'b0;
        #1;

        check_outputs(32'hAAAAAAA0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %03d: Pattern shift (0xAAAAAAAA) right by 4", test_num);
        data = 32'hAAAAAAAA;
        shift = 5'd4;
        shift_right = 1'b1;
        #1;

        check_outputs(32'h0AAAAAAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_shifted_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h",
                         shifted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h",
                         expected_shifted_data);
                $display("  Got:      shifted_data=%h",
                         shifted_data);
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
