`timescale 1ns/1ps

module greater_than_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    greater_than dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10; B = 8'd5; C = 8'd2;
            $display("Test Case %0d: A=%d, B=%d, C=%d (A > B and C < B)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd5; B = 8'd5; C = 8'd4;
            $display("Test Case %0d: A=%d, B=%d, C=%d (A = B and C < B)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd4; B = 8'd5; C = 8'd2;
            $display("Test Case %0d: A=%d, B=%d, C=%d (A < B and C < B)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'd10; B = 8'd5; C = 8'd5;
            $display("Test Case %0d: A=%d, B=%d, C=%d (A > B and C = B)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'd10; B = 8'd5; C = 8'd6;
            $display("Test Case %0d: A=%d, B=%d, C=%d (A > B and C > B)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'd0; B = 8'd0; C = 8'd0;
            $display("Test Case %0d: A=%d, B=%d, C=%d (All zeros - C < B is false)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd255; B = 8'd255; C = 8'd254;
            $display("Test Case %0d: A=%d, B=%d, C=%d (Boundary max values)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'd128; B = 8'd128; C = 8'd128;
            $display("Test Case %0d: A=%d, B=%d, C=%d (All equal)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'd255; B = 8'd0; C = 8'd0;
            $display("Test Case %0d: A=%d, B=%d, C=%d (B is zero, C cannot be less than zero)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'd200; B = 8'd100; C = 8'd0;
            $display("Test Case %0d: A=%d, B=%d, C=%d (C is zero, B > zero)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("greater_than Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
