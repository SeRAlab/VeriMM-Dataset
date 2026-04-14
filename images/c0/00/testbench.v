`timescale 1ns/1ps

module alu_shifter_core_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] db;
    reg shift_in;
    reg shift_left;
    reg shift_right;
    wire [3:0] out_high;
    wire [3:0] out_low;
    wire shift_db0;
    wire shift_db7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_shifter_core dut (
        .db(db),
        .shift_in(shift_in),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .out_high(out_high),
        .out_low(out_low),
        .shift_db0(shift_db0),
        .shift_db7(shift_db7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Shift (db=8'hA5, shift_in=0)", test_num);

            db = 8'hA5;
            shift_in = 0;
            shift_left = 0;
            shift_right = 0;




            #1;





            check_outputs(4'hA, 4'h5, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right with shift_in=1 (db=8'hB2)", test_num);

            db = 8'hB2;
            shift_in = 1;
            shift_left = 0;
            shift_right = 1;




            #1;





            check_outputs(4'hD, 4'h9, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Right with shift_in=0 (db=8'hB2)", test_num);

            db = 8'hB2;
            shift_in = 0;
            shift_left = 0;
            shift_right = 1;




            #1;





            check_outputs(4'h5, 4'h9, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left with shift_in=1 (db=8'h4D)", test_num);

            db = 8'h4D;
            shift_in = 1;
            shift_left = 1;
            shift_right = 0;




            #1;





            check_outputs(4'h9, 4'hB, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Left with shift_in=0 (db=8'h4D)", test_num);

            db = 8'h4D;
            shift_in = 0;
            shift_left = 1;
            shift_right = 0;




            #1;





            check_outputs(4'h9, 4'hA, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary - Shift Right All Zeros (db=8'h01, shift_in=0)", test_num);

            db = 8'h01;
            shift_in = 0;
            shift_left = 0;
            shift_right = 1;


            #1;



            check_outputs(4'h0, 4'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary - Shift Left All Ones (db=8'hFF, shift_in=1)", test_num);

            db = 8'hFF;
            shift_in = 1;
            shift_left = 1;
            shift_right = 0;


            #1;



            check_outputs(4'hF, 4'hF, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_shifter_core Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_out_high;
        input [3:0] expected_out_low;
        input expected_shift_db0;
        input expected_shift_db7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_high === (expected_out_high ^ out_high ^ expected_out_high) &&
                expected_out_low === (expected_out_low ^ out_low ^ expected_out_low) &&
                expected_shift_db0 === (expected_shift_db0 ^ shift_db0 ^ expected_shift_db0) &&
                expected_shift_db7 === (expected_shift_db7 ^ shift_db7 ^ expected_shift_db7)) begin
                $display("PASS");
                $display("  Outputs: out_high=%h, out_low=%h, shift_db0=%b, shift_db7=%b",
                         out_high, out_low, shift_db0, shift_db7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_high=%h, out_low=%h, shift_db0=%b, shift_db7=%b",
                         expected_out_high, expected_out_low, expected_shift_db0, expected_shift_db7);
                $display("  Got:      out_high=%h, out_low=%h, shift_db0=%b, shift_db7=%b",
                         out_high, out_low, shift_db0, shift_db7);
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
