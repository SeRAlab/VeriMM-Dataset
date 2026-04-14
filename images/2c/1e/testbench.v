`timescale 1ns/1ps

module multiplier_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_4bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd0;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd1;
            B = 4'd1;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd1;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd3;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd3;
            B = 4'd7;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd4;
            B = 4'd8;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd13;
            B = 4'd11;
            $display("Test Case %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(8'd143);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_4bit Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
