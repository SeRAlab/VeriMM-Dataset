`timescale 1ns/1ps

module shift_left_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_left dut (
        .A(A),
        .B(B),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b1010;
        B = 4'd0;
        $display("Test %0d: A=%b, B=%0d (No shift)", test_num, A, B);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0011;
        B = 4'd1;
        $display("Test %0d: A=%b, B=%0d (Shift left by 1)", test_num, A, B);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b0001;
        B = 4'd2;
        $display("Test %0d: A=%b, B=%0d (Shift left by 2)", test_num, A, B);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b0001;
        B = 4'd3;
        $display("Test %0d: A=%b, B=%0d (Shift left by 3)", test_num, A, B);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1100;
        B = 4'd2;
        $display("Test %0d: A=%b, B=%0d (Data bits shifted out)", test_num, A, B);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1111;
        B = 4'd4;
        $display("Test %0d: A=%b, B=%0d (Boundary B=4)", test_num, A, B);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b0101;
        B = 4'd15;
        $display("Test %0d: A=%b, B=%0d (Maximum B value)", test_num, A, B);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b0000;
        B = 4'd2;
        $display("Test %0d: A=%b, B=%0d (A is zero)", test_num, A, B);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1111;
        B = 4'd3;
        $display("Test %0d: A=%b, B=%0d (Max valid shift)", test_num, A, B);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_left Testbench");
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
        input [3:0] expected_out;
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
