`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [2:0] shift_amount;
    reg shift_right;
    wire [7:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .shift_amount(shift_amount),
        .shift_right(shift_right),
        .shifted_data(shifted_data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No shift (shift_amount=0, left)", test_num);
        data = 8'hA5;
        shift_amount = 3'd0;
        shift_right = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: No shift (shift_amount=0, right)", test_num);
        data = 8'h5A;
        shift_amount = 3'd0;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Left shift by 1", test_num);
        data = 8'hFF;
        shift_amount = 3'd1;
        shift_right = 1'b0;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Right shift by 1", test_num);
        data = 8'hFF;
        shift_amount = 3'd1;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Left shift by 4", test_num);
        data = 8'h0F;
        shift_amount = 3'd4;
        shift_right = 1'b0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Right shift by 4", test_num);
        data = 8'hF0;
        shift_amount = 3'd4;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Left shift by 7 (Maximum)", test_num);
        data = 8'h01;
        shift_amount = 3'd7;
        shift_right = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Right shift by 7 (Maximum)", test_num);
        data = 8'h80;
        shift_amount = 3'd7;
        shift_right = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Left shift into zero (All bits out)", test_num);
        data = 8'hAA;
        shift_amount = 3'd7;
        shift_right = 1'b0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Right shift into zero (All bits out)", test_num);
        data = 8'h55;
        shift_amount = 3'd7;
        shift_right = 1'b1;

        #1;


        check_outputs(8'h00);
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
        input [7:0] expected_shifted_data;
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
