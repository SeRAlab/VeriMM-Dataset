`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg direction;
    reg [2:0] shift_amt;
    wire [7:0] shifted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .direction(direction),
        .shift_amt(shift_amt),
        .shifted_data(shifted_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Left by 0", test_num);
            data_in = 8'hA5;
            shift_amt = 3'd0;
            direction = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Right by 0", test_num);
            data_in = 8'hA5;
            shift_amt = 3'd0;
            direction = 1'b1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Left by 1", test_num);
            data_in = 8'b10000001;
            shift_amt = 3'd1;
            direction = 1'b0;

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Right by 1", test_num);
            data_in = 8'b10000001;
            shift_amt = 3'd1;
            direction = 1'b1;

            #1;


            check_outputs(8'hC0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Left by 4", test_num);
            data_in = 8'hF0;
            shift_amt = 3'd4;
            direction = 1'b0;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Right by 4", test_num);
            data_in = 8'h0F;
            shift_amt = 3'd4;
            direction = 1'b1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Left by 7 (Max Shift)", test_num);
            data_in = 8'b01111111;
            shift_amt = 3'd7;
            direction = 1'b0;


            #1;



            check_outputs(8'hBF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rotate Right by 7 (Max Shift)", test_num);
            data_in = 8'b11111110;
            shift_amt = 3'd7;
            direction = 1'b1;


            #1;



            check_outputs(8'hFD);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Periodic Pattern Rotate (0x55)", test_num);
            data_in = 8'h55;
            shift_amt = 3'd2;
            direction = 1'b0;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complex Pattern Rotate Right", test_num);
            data_in = 8'h12;
            shift_amt = 3'd3;
            direction = 1'b1;



            #1;




            check_outputs(8'h42);
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
