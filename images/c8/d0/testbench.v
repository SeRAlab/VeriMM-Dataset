`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Addition (15 + 10)", test_num);
            A = 8'd15;
            B = 8'd10;
            C = 1'b0;
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Subtraction (15 - 10)", test_num);
            A = 8'd15;
            B = 8'd10;
            C = 1'b1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with Overflow (255 + 2)", test_num);
            A = 8'd255;
            B = 8'd2;
            C = 1'b0;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction with Underflow (2 - 5)", test_num);
            A = 8'd2;
            B = 8'd5;
            C = 1'b1;
            #1;

            check_outputs(8'd253);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Addition (0 + 0)", test_num);
            A = 8'd0;
            B = 8'd0;
            C = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction Resulting in Zero (128 - 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            C = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Adding Max Values (128 + 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            C = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Subtraction Wrap (100 - 200)", test_num);
            A = 8'd100;
            B = 8'd200;
            C = 1'b1;
            #1;

            check_outputs(8'd156);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
