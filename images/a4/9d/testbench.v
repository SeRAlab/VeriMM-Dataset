`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    reg [4:0] shift_amount;
    reg shift_direction;
    wire [31:0] shifted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift_amount(shift_amount),
        .shift_direction(shift_direction),
        .shifted_output(shifted_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift by 0 (No change)", test_num);
        data = 32'h12345678;
        shift_amount = 5'd0;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right shift by 0 (No change)", test_num);
        data = 32'h12345678;
        shift_amount = 5'd0;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift by 1", test_num);
        data = 32'h00000001;
        shift_amount = 5'd1;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right shift by 1", test_num);
        data = 32'h80000000;
        shift_amount = 5'd1;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift by 8 (Byte shift)", test_num);
        data = 32'h000000FF;
        shift_amount = 5'd8;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'h0000FF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right shift by 8 (Byte shift)", test_num);
        data = 32'hFF000000;
        shift_amount = 5'd8;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h00FF0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift by 16 (Half-word shift)", test_num);
        data = 32'h0000FFFF;
        shift_amount = 5'd16;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right shift by 16 (Half-word shift)", test_num);
        data = 32'hFFFF0000;
        shift_amount = 5'd16;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left shift by 31 (Max shift)", test_num);
        data = 32'h00000001;
        shift_amount = 5'd31;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right shift by 31 (Max shift)", test_num);
        data = 32'h80000000;
        shift_amount = 5'd31;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift all ones left (Check zero fill)", test_num);
        data = 32'hFFFFFFFF;
        shift_amount = 5'd4;
        shift_direction = 1'b0;
        #1;

        check_outputs(32'hFFFFFFF0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift all ones right (Check zero fill)", test_num);
        data = 32'hFFFFFFFF;
        shift_amount = 5'd4;
        shift_direction = 1'b1;
        #1;

        check_outputs(32'h0FFFFFFF);
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
        input [31:0] expected_shifted_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_output === (expected_shifted_output ^ shifted_output ^ expected_shifted_output)) begin
                $display("PASS");
                $display("  Outputs: shifted_output=%h",
                         shifted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_output=%h",
                         expected_shifted_output);
                $display("  Got:      shifted_output=%h",
                         shifted_output);
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
