`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [3:0] shift_amount;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No shift (0000)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0000;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift left by 1 (0001)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0001;
        #1;

        check_outputs(8'h4A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift left by 2 (0010)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0010;
        #1;

        check_outputs(8'h94);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift left by 3 (0011)", test_num);
        data_in = 8'hFF;
        shift_amount = 4'b0011;
        #1;

        check_outputs(8'hF8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift right by 1 (0100)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0100;
        #1;

        check_outputs(8'h52);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift right by 2 (0101)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0101;
        #1;

        check_outputs(8'h29);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift right by 3 (0110)", test_num);
        data_in = 8'hA5;
        shift_amount = 4'b0110;
        #1;

        check_outputs(8'h14);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift right by 4 (0111)", test_num);
        data_in = 8'hF0;
        shift_amount = 4'b0111;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones, Left 1", test_num);
        data_in = 8'hFF;
        shift_amount = 4'b0001;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones, Right 4", test_num);
        data_in = 8'hFF;
        shift_amount = 4'b0111;
        #1;

        check_outputs(8'h0F);
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
        input [7:0] expected_data_out;
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
