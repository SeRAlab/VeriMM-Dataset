`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: a=0, b=0 (Zero Addition)", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: a=5, b=3 (Simple Addition)", test_num);
            a = 4'd5;
            b = 4'd3;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: a=15, b=0 (Identity Addition)", test_num);
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: a=8, b=8 (Carry-out Boundary)", test_num);
            a = 4'd8;
            b = 4'd8;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: a=15, b=1 (Carry-out Boundary Max)", test_num);
            a = 4'd15;
            b = 4'd1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: a=15, b=15 (Maximum inputs)", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: a=7, b=9 (Result 16)", test_num);
            a = 4'd7;
            b = 4'd9;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: a=10, b=5 (Result 15, no carry)", test_num);
            a = 4'd10;
            b = 4'd5;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_sum;
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
