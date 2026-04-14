`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg [3:0] shift_amount;
    wire [15:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift_amount(shift_amount),
        .shifted_data(shifted_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No shift (shift_amount = 0)", test_num);
            data = 16'hABCD;
            shift_amount = 4'd0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift by 1", test_num);
            data = 16'h0001;
            shift_amount = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift by 4 (nibble shift)", test_num);
            data = 16'h000F;
            shift_amount = 4'd4;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift by 8 (byte shift)", test_num);
            data = 16'h00FF;
            shift_amount = 4'd8;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum shift (15)", test_num);
            data = 16'h0001;
            shift_amount = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data shift out (overflow)", test_num);
            data = 16'h8000;
            shift_amount = 4'd1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones data, shift 12", test_num);
            data = 16'hFFFF;
            shift_amount = 4'd12;
            #1;

            check_outputs(16'hF000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero data, shift 5", test_num);
            data = 16'h0000;
            shift_amount = 4'd5;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits, shift 2", test_num);
            data = 16'hAAAA;
            shift_amount = 4'd2;
            #1;

            check_outputs(16'hAAA8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex shift logic", test_num);
            data = 16'h1234;
            shift_amount = 4'd7;


            #1;



            check_outputs(16'h9A00);
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
        input [15:0] expected_shifted_data;
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
