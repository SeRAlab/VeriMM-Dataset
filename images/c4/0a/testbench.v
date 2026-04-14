`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00;
            B = 8'h00;
            $display("\nTest %0d: All Zeros", test_num);
            #1;

            check_outputs(8'h00 & 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            $display("\nTest %0d: All Ones", test_num);
            #1;

            check_outputs(8'hFF & 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'hAA;
            B = 8'h55;
            $display("\nTest %0d: Non-overlapping patterns (result should be 0)", test_num);
            #1;

            check_outputs(8'hAA & 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hF0;
            B = 8'hCC;
            $display("\nTest %0d: Partial overlap", test_num);
            #1;

            check_outputs(8'hF0 & 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'h0F;
            B = 8'hFF;
            $display("\nTest %0d: Subset pattern", test_num);
            #1;

            check_outputs(8'h0F & 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = $urandom_range(0, 255);
            B = $urandom_range(0, 255);
            $display("\nTest %0d: Random Input 1 (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(A & B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = $urandom_range(0, 255);
            B = $urandom_range(0, 255);
            $display("\nTest %0d: Random Input 2 (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(A & B);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = $urandom_range(0, 255);
            B = $urandom_range(0, 255);
            $display("\nTest %0d: Random Input 3 (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(A & B);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = $urandom_range(0, 255);
            B = $urandom_range(0, 255);
            $display("\nTest %0d: Random Input 4 (A=%h, B=%h)", test_num, A, B);
            #1;

            check_outputs(A & B);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = $urandom_range(0, 255);
            B = A;
            $display("\nTest %0d: Matching Random (A=B=%h)", test_num, A);
            #1;

            check_outputs(A & B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
