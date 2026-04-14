`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [2:0] shift_amount;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .shift_right(shift_right),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left by 0 bits", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd0;
        shift_right = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left by 1 bit", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd1;
        shift_right = 1'b0;
        #1;

        check_outputs(8'h4A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left by 4 bits", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd4;
        shift_right = 1'b0;
        #1;

        check_outputs(8'h50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left by 7 bits", test_num);
        data_in = 8'hFF;
        shift_amount = 3'd7;
        shift_right = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right by 0 bits", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd0;
        shift_right = 1'b1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right by 1 bit", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd1;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h52);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right by 4 bits", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd4;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right by 7 bits", test_num);
        data_in = 8'hFF;
        shift_amount = 3'd7;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input zero, shift left 3", test_num);
        data_in = 8'h00;
        shift_amount = 3'd3;
        shift_right = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit shift right", test_num);
        data_in = 8'h80;
        shift_amount = 3'd7;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h01);
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
