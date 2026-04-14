`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg dir;
    reg [4:0] shift_amt;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .dir(dir),
        .shift_amt(shift_amt),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Left Shift by 0", test_num);
        data_in = 32'h12345678;
        dir = 0;
        shift_amt = 5'd0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Right Shift by 0", test_num);
        data_in = 32'hA5A5A5A5;
        dir = 1;
        shift_amt = 5'd0;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Left Shift by 1", test_num);
        data_in = 32'h80000001;
        dir = 0;
        shift_amt = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Right Shift by 1", test_num);
        data_in = 32'h80000001;
        dir = 1;
        shift_amt = 5'd1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Left Shift by 4", test_num);
        data_in = 32'h0000000F;
        dir = 0;
        shift_amt = 5'd4;
        #1;

        check_outputs(32'h000000F0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Right Shift by 4", test_num);
        data_in = 32'hF0000000;
        dir = 1;
        shift_amt = 5'd4;
        #1;

        check_outputs(32'h0F000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Left Shift by 16", test_num);
        data_in = 32'h0000FFFF;
        dir = 0;
        shift_amt = 5'd16;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %03d: Right Shift by 16", test_num);
        data_in = 32'hFFFF0000;
        dir = 1;
        shift_amt = 5'd16;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %03d: Left Shift by 31", test_num);
        data_in = 32'hFFFFFFFF;
        dir = 0;
        shift_amt = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %03d: Right Shift by 31", test_num);
        data_in = 32'hFFFFFFFF;
        dir = 1;
        shift_amt = 5'd31;
        #1;

        check_outputs(32'h00000001);
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
        input [31:0] expected_data_out;
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
