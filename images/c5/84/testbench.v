`timescale 1ns/1ps

module adder_8bit_valid_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Valid_add;
    wire [8:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit_valid dut (
        .A(A),
        .B(B),
        .Valid_add(Valid_add),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd20;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd0;
            B = 8'd0;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd255;
            B = 8'd255;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd510);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'd255;
            B = 8'd1;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hAA;
            B = 8'h55;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'd50;
            B = 8'd50;
            Valid_add = 1'b0;

            #1;


            check_outputs(9'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd127;
            B = 8'd128;
            Valid_add = 1'b1;
            #1;

            check_outputs(9'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit_valid Testbench");
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
        input [8:0] expected_Sum;
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
