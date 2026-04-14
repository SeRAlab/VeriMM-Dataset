`timescale 1ns/1ps

module arithmetic_right_shift_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arithmetic_right_shift dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive number, shift 0", test_num);
        data_in = 4'b0110;
        shift_amount = 2'd0;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive number, shift 1", test_num);
        data_in = 4'b0110;
        shift_amount = 2'd1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive number, shift 2", test_num);
        data_in = 4'b0100;
        shift_amount = 2'd2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive number, shift 3 (all bits cleared)", test_num);
        data_in = 4'b0111;
        shift_amount = 2'd3;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative number, shift 0", test_num);
        data_in = 4'b1010;
        shift_amount = 2'd0;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative number, shift 1 (sign extension)", test_num);
        data_in = 4'b1010;
        shift_amount = 2'd1;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative number, shift 2 (sign extension)", test_num);
        data_in = 4'b1100;
        shift_amount = 2'd2;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative number, shift 3 (becomes -1)", test_num);
        data_in = 4'b1000;
        shift_amount = 2'd3;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input", test_num);
        data_in = 4'b0000;
        shift_amount = 2'd2;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max shift on -1", test_num);
        data_in = 4'b1111;
        shift_amount = 2'd3;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arithmetic_right_shift Testbench");
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
