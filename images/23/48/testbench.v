`timescale 1ns/1ps

module matrix_mult_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_mult dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;


            A = 16'h4321;
            B = 16'h1001;
            $display("Test %0d: Multiplication by Identity Matrix (A * I = A)", test_num);
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            A = 16'hFFFF;
            B = 16'h0000;
            $display("Test %0d: Multiplication by Zero Matrix (A * 0 = 0)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;


            A = 16'h1111;
            B = 16'h1111;
            $display("Test %0d: All-ones Matrix Multiplication", test_num);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;



            A = 16'h4321;
            B = 16'h0110;
            $display("Test %0d: Multiplication by Exchange Matrix", test_num);
            #1;

            check_outputs(16'h3412);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;





            A = 16'h2012;
            B = 16'h4123;
            $display("Test %0d: Arbitrary Integer Matrix Multiplication", test_num);
            #1;

            check_outputs(16'h8287);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;


            A = 16'h3002;
            B = 16'h1004;
            $display("Test %0d: Diagonal Matrix Multiplication", test_num);
            #1;

            check_outputs(16'h3008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_mult Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_C;
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
