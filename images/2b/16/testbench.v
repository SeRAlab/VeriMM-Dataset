`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'b0000;
            B = 4'b0000;
            Cin = 1'b0;
            $display("Test %0d: A=0, B=0, Cin=0", test_num);
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1111;
            Cin = 1'b1;
            $display("Test %0d: A=15, B=15, Cin=1", test_num);

            #1;


            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            Cin = 1'b0;
            $display("Test %0d: A=5, B=3, Cin=0", test_num);
            #1;

            check_outputs(1'b0, 5'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            Cin = 1'b0;
            $display("Test %0d: A=8, B=8, Cin=0 (Sum=16)", test_num);

            #1;


            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b0000;
            Cin = 1'b1;
            $display("Test %0d: A=15, B=0, Cin=1 (Sum=16)", test_num);
            #1;

            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b0111;
            B = 4'b0001;
            Cin = 1'b0;
            $display("Test %0d: A=7, B=1, Cin=0", test_num);
            #1;

            check_outputs(1'b0, 5'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            Cin = 1'b1;
            $display("Test %0d: A=10, B=5, Cin=1", test_num);

            #1;


            check_outputs(1'b1, 5'd16);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input expected_Cout;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
