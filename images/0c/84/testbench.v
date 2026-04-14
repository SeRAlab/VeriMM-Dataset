`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire [1:0] Q;
    wire [1:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .A(A),
        .B(B),
        .Q(Q),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=1", test_num);
            A = 2'b00; B = 2'b01;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=1", test_num);
            A = 2'b01; B = 2'b01;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=2, B=1", test_num);
            A = 2'b10; B = 2'b01;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=3, B=1", test_num);
            A = 2'b11; B = 2'b01;
            #1;

            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=2", test_num);
            A = 2'b00; B = 2'b10;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=2", test_num);
            A = 2'b01; B = 2'b10;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=2, B=2", test_num);
            A = 2'b10; B = 2'b10;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=3, B=2", test_num);
            A = 2'b11; B = 2'b10;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=3", test_num);
            A = 2'b00; B = 2'b11;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=3, B=3", test_num);
            A = 2'b11; B = 2'b11;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=0 (Divide by Zero)", test_num);
            A = 2'b01; B = 2'b00;
            #1;

            check_outputs(2'bxx, 2'bxx);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=3, B=0 (Divide by Zero)", test_num);
            A = 2'b11; B = 2'b00;
            #1;

            check_outputs(2'bxx, 2'bxx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_2bit Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [1:0] expected_Q;
        input [1:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
