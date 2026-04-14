`timescale 1ns/1ps

module arith_right_shift_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] shift_amount;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arith_right_shift dut (
        .in(in),
        .shift_amount(shift_amount),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero input, non-zero shift", test_num);
            in = 16'h0000;
            shift_amount = 4'd5;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones input, any shift", test_num);
            in = 16'hFFFF;
            shift_amount = 4'd8;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift by zero (Positive number)", test_num);
            in = 16'h1234;
            shift_amount = 4'd0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift by zero (Negative number)", test_num);
            in = 16'h8000;
            shift_amount = 4'd0;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Positive number shift right by 1", test_num);
            in = 16'h4000;
            shift_amount = 4'd1;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Negative number shift right by 1 (Sign extension)", test_num);
            in = 16'h8000;
            shift_amount = 4'd1;
            #1;

            check_outputs(16'hC000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Negative number shift right by 4", test_num);
            in = 16'h8000;
            shift_amount = 4'd4;
            #1;

            check_outputs(16'hF800);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Positive number max shift (15)", test_num);
            in = 16'h7FFF;
            shift_amount = 4'd15;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Negative number max shift (15)", test_num);
            in = 16'h8001;
            shift_amount = 4'd15;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Arbitrary negative value shift", test_num);
            in = 16'hABCD;
            shift_amount = 4'd8;

            #1;


            check_outputs(16'hFFAB);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Arbitrary positive value shift", test_num);
            in = 16'h5555;
            shift_amount = 4'd2;

            #1;


            check_outputs(16'h1555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arith_right_shift Testbench");
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
        testcase011();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
