`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [3:0] shift_amount;
    wire overflow;
    wire [15:0] shifted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .overflow(overflow),
        .shifted_output(shifted_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_in = 16'hABCD;
            shift_amount = 4'd0;
            $display("Test Case %0d: No shift (shift_amount=0)", test_num);
            #1;

            check_outputs(1'b0, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_in = 16'h0001;
            shift_amount = 4'd1;
            $display("Test Case %0d: Circular right shift 1 on LSB", test_num);

            #1;


            check_outputs(1'b0, 16'h8000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_in = 16'h1234;
            shift_amount = 4'd4;
            $display("Test Case %0d: Circular right shift by 4", test_num);

            #1;


            check_outputs(1'b0, 16'h4123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_in = 16'hFF00;
            shift_amount = 4'd8;
            $display("Test Case %0d: Circular right shift by 8", test_num);

            #1;


            check_outputs(1'b0, 16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_in = 16'hF000;
            shift_amount = 4'd12;
            $display("Test Case %0d: Shift by 12 (Boundary check)", test_num);

            #1;


            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_in = 16'hAAAA;
            shift_amount = 4'd13;
            $display("Test Case %0d: Shift by 13 (Overflow expected)", test_num);




            #1;





            check_outputs(1'b1, 16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_in = 16'h8000;
            shift_amount = 4'd15;
            $display("Test Case %0d: Shift by 15 (Max overflow)", test_num);

            #1;


            check_outputs(1'b1, 16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data_in = 16'hFFFF;
            shift_amount = 4'd7;
            $display("Test Case %0d: All ones data", test_num);
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            data_in = 16'h0000;
            shift_amount = 4'd14;
            $display("Test Case %0d: All zeros data with overflow", test_num);
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            data_in = 16'hF0F0;
            shift_amount = 4'd4;
            $display("Test Case %0d: Circular shift on pattern F0F0", test_num);

            #1;


            check_outputs(1'b0, 16'h0F0F);
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
        input expected_overflow;
        input [15:0] expected_shifted_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_shifted_output === (expected_shifted_output ^ shifted_output ^ expected_shifted_output)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, shifted_output=%h",
                         overflow, shifted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, shifted_output=%h",
                         expected_overflow, expected_shifted_output);
                $display("  Got:      overflow=%b, shifted_output=%h",
                         overflow, shifted_output);
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
