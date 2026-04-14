`timescale 1ns/1ps

module kogge_stone_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kogge_stone_adder dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);
            A = 4'h0;
            B = 4'h0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (5 + 3)", test_num);
            A = 4'h5;
            B = 4'h3;
            #1;

            check_outputs(5'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Case - Max without Carry Out (7 + 8)", test_num);
            A = 4'h7;
            B = 4'h8;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Carry Out (8 + 8)", test_num);
            A = 4'h8;
            B = 4'h8;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (15 + 15)", test_num);
            A = 4'hF;
            B = 4'hF;
            #1;

            check_outputs(5'h1E);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Pattern A (1010 + 0101)", test_num);
            A = 4'b1010;
            B = 4'b0101;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Propagation (15 + 1)", test_num);
            A = 4'hF;
            B = 4'h1;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime Numbers (13 + 7)", test_num);
            A = 4'd13;
            B = 4'd7;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (4 + 4)", test_num);
            A = 4'd4;
            B = 4'd4;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum A with zero B (15 + 0)", test_num);
            A = 4'hF;
            B = 4'h0;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kogge_stone_adder Testbench");
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
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
