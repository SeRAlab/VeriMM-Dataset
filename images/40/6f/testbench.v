`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg direction;
    reg [2:0] shift_amount;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .direction(direction),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Shift Left by 0 (No change)", test_num);
        data_in = 8'hFF;
        direction = 0;
        shift_amount = 3'd0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Shift Left by 1", test_num);
        data_in = 8'hFF;
        direction = 0;
        shift_amount = 3'd1;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Shift Left by 4", test_num);
        data_in = 8'hAA;
        direction = 0;
        shift_amount = 3'd4;
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Shift Left by 7 (Max Left)", test_num);
        data_in = 8'h01;
        direction = 0;
        shift_amount = 3'd7;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Shift Right by 0 (No change)", test_num);
        data_in = 8'hFF;
        direction = 1;
        shift_amount = 3'd0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Shift Right by 1", test_num);
        data_in = 8'hFF;
        direction = 1;
        shift_amount = 3'd1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Shift Right by 4", test_num);
        data_in = 8'h55;
        direction = 1;
        shift_amount = 3'd4;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Shift Right by 7 (Max Right)", test_num);
        data_in = 8'h80;
        direction = 1;
        shift_amount = 3'd7;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Shift Left by 3", test_num);
        data_in = 8'h12;
        direction = 0;
        shift_amount = 3'd3;
        #1;

        check_outputs(8'h90);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Shift Right by 2", test_num);
        data_in = 8'hC3;
        direction = 1;
        shift_amount = 3'd2;
        #1;

        check_outputs(8'h30);
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
