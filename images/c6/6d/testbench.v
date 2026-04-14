`timescale 1ns/1ps

module add8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add8bit dut (
        .A(A),
        .B(B),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd0;
        B = 8'd0;
        $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd10;
        B = 8'd20;
        $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'hFF;
        B = 8'h00;
        $display("Test Case %0d: Boundary Check (255 + 0)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd127;
        B = 8'd128;
        $display("Test Case %0d: Boundary Check (127 + 128)", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'hFF;
        B = 8'h01;
        $display("Test Case %0d: Overflow Check (255 + 1)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'hFF;
        B = 8'hFF;
        $display("Test Case %0d: Max Overflow Check (255 + 255)", test_num);
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'h55;
        B = 8'hAA;
        $display("Test Case %0d: Pattern Addition (0101 + 1010)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'd123;
        B = 8'd45;
        $display("Test Case %0d: Random Values (123 + 45)", test_num);
        #1;

        check_outputs(8'd168);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add8bit Testbench");
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
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
