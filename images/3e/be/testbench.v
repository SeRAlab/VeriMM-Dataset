`timescale 1ns/1ps

module monte_carlo_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg [4:0] C;
    wire [4:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 5'd0; B = 5'd0; C = 5'd0;
            $display("\nTest %0d: All Zeros", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 5'd10; B = 5'd5; C = 5'd0;
            $display("\nTest %0d: Basic Addition (No Overflow, No XOR change)", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 5'd1; B = 5'd2; C = 5'd3;
            $display("\nTest %0d: Addition and XOR cancellation", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 5'd16; B = 5'd16; C = 5'd0;
            $display("\nTest %0d: Overflow to Zero", test_num);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 5'd31; B = 5'd1; C = 5'd5;
            $display("\nTest %0d: Overflow and XOR", test_num);
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 5'd31; B = 5'd31; C = 5'd31;
            $display("\nTest %0d: Max Values", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 5'h19; B = 5'h0A; C = 5'h03;
            $display("\nTest %0d: Arbitrary Pattern 1", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 5'h0A; B = 5'h05; C = 5'h1F;
            $display("\nTest %0d: Arbitrary Pattern 2", test_num);
            #1;

            check_outputs(5'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_adder Testbench");
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
        input [4:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
