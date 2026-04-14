`timescale 1ns/1ps

module adder_4bit_structural_tb;

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
    adder_4bit_structural dut (
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Adding zero to zero", test_num);
            a = 4'b0000;
            b = 4'b0000;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple addition without carry-out", test_num);
            a = 4'd5;
            b = 4'd3;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum sum without carry-out", test_num);
            a = 4'd7;
            b = 4'd8;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Addition resulting in exact carry-out (16)", test_num);
            a = 4'd8;
            b = 4'd8;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum possible inputs", test_num);
            a = 4'b1111;
            b = 4'b1111;

            #1;


            check_outputs(1'b1, 4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Single bit carry propagation (0111 + 0001)", test_num);
            a = 4'b0111;
            b = 4'b0001;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Overflow with mixed bits", test_num);
            a = 4'd12;
            b = 4'd7;

            #1;


            check_outputs(1'b1, 4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit_structural Testbench");
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
