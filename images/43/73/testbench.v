`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [6:0] in1;
    reg [6:0] in2;
    wire cout;
    wire [6:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in1(in1),
        .in2(in2),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All zeros", test_num);
            in1 = 7'd0;
            in2 = 7'd0;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Simple addition no carry-out", test_num);
            in1 = 7'd10;
            in2 = 7'd25;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 7'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Addition with carry-in", test_num);
            in1 = 7'd15;
            in2 = 7'd20;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 7'd36);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary - Max 7-bit sum (127)", test_num);
            in1 = 7'h3F;
            in2 = 7'h40;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 7'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single bit carry-out", test_num);
            in1 = 7'h7F;
            in2 = 7'h01;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Maximum possible values", test_num);
            in1 = 7'h7F;
            in2 = 7'h7F;
            cin = 1'b1;


            #1;



            check_outputs(1'b1, 7'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Propagate through all bits", test_num);
            in1 = 7'b1010101;
            in2 = 7'b0101010;
            cin = 1'b1;

            #1;


            check_outputs(1'b1, 7'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Random pattern 1", test_num);
            in1 = 7'h5A;
            in2 = 7'h12;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 7'h6C);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Carry-out from mid-bits", test_num);
            in1 = 7'h40;
            in2 = 7'h40;
            cin = 1'b0;

            #1;


            check_outputs(1'b1, 7'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Sparse bits", test_num);
            in1 = 7'b0010010;
            in2 = 7'b0001001;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 7'b0011100);
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
        input expected_cout;
        input [6:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
