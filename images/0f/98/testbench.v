`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire COUT;
    wire [15:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition without carry", test_num);
            A = 16'h1234;
            B = 16'h4321;
            #1;

            check_outputs(1'b0, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry (All ones)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-out generation at boundary", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry-out from Most Significant Bit", test_num);
            A = 16'h8000;
            B = 16'h8000;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs maximum values", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(1'b1, 16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary large values with carry", test_num);
            A = 16'hC001;
            B = 16'hD002;

            #1;


            check_outputs(1'b1, 16'h9003);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit test", test_num);
            A = 16'h0080;
            B = 16'h0080;
            #1;

            check_outputs(1'b0, 16'h0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input expected_COUT;
        input [15:0] expected_SUM;
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
