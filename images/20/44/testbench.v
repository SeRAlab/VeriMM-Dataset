`timescale 1ns/1ps

module KoggeStoneAdder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire COUT;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KoggeStoneAdder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            A = 4'b0000; B = 4'b0000;
            #5;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (No Carry)", test_num);
            A = 4'b0011; B = 4'b0100;
            #5;
            #1;

            check_outputs(1'b0, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal Carry Generation", test_num);
            A = 4'b0101; B = 4'b0101;
            #5;
            #1;

            check_outputs(1'b0, 4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (Carry Out)", test_num);
            A = 4'b1111; B = 4'b1111;
            #5;
            #1;

            check_outputs(1'b1, 4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Carry Chain Propagation", test_num);
            A = 4'b1111; B = 4'b0001;
            #5;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Patterns", test_num);
            A = 4'b1010; B = 4'b0101;
            #5;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB Carry Out", test_num);
            A = 4'b1000; B = 4'b1000;
            #5;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Case 1", test_num);
            A = 4'b1001; B = 4'b0111;
            #5;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Case 2", test_num);
            A = 4'b1100; B = 4'b0011;
            #5;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Addition", test_num);
            A = 4'b0001; B = 4'b0001;
            #5;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KoggeStoneAdder Testbench");
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
        input expected_COUT;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
