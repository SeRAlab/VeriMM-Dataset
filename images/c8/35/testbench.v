`timescale 1ns/1ps

module add_subtract_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_subtract dut (
        .A(A),
        .B(B),
        .C(C),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Addition (15 + 10)", test_num);
        A = 8'd15;
        B = 8'd10;
        C = 1'b1;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Subtraction (50 - 20)", test_num);
        A = 8'd50;
        B = 8'd20;
        C = 1'b0;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (250 + 10)", test_num);
        A = 8'd250;
        B = 8'd10;
        C = 1'b1;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Underflow (5 - 10)", test_num);
        A = 8'd5;
        B = 8'd10;
        C = 1'b0;
        #1;

        check_outputs(8'd251);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition result zero (128 + 128)", test_num);
        A = 8'd128;
        B = 8'd128;
        C = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction result zero (255 - 255)", test_num);
        A = 8'd255;
        B = 8'd255;
        C = 1'b0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values addition (255 + 255)", test_num);
        A = 8'd255;
        B = 8'd255;
        C = 1'b1;
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min value subtraction (0 - 1)", test_num);
        A = 8'd0;
        B = 8'd1;
        C = 1'b0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_subtract Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
