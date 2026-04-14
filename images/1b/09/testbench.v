`timescale 1ns/1ps

module matrix_multiply_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg [3:0] B0;
    reg [3:0] B1;
    reg [3:0] B2;
    reg [3:0] B3;
    wire [3:0] C0;
    wire [3:0] C1;
    wire [3:0] C2;
    wire [3:0] C3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiply dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C0(C0),
        .C1(C1),
        .C2(C2),
        .C3(C3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Matrix B", test_num);

            A0 = 4'h1; A1 = 4'h2;
            A2 = 4'h3; A3 = 4'h4;

            B0 = 4'h1; B1 = 4'h0;
            B2 = 4'h0; B3 = 4'h1;


            #1;



            check_outputs(4'h1, 4'h2, 4'h3, 4'h4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Matrix B", test_num);
            A0 = 4'hF; A1 = 4'hF;
            A2 = 4'hF; A3 = 4'hF;
            B0 = 4'h0; B1 = 4'h0;
            B2 = 4'h0; B3 = 4'h10;
            B3 = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small values no overflow", test_num);

            A0 = 4'h2; A1 = 4'h1;
            A2 = 4'h1; A3 = 4'h2;

            B0 = 4'h1; B1 = 4'h2;
            B2 = 4'h2; B3 = 4'h1;





            #1;






            check_outputs(4'h4, 4'h5, 4'h5, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow (Modulo 16)", test_num);

            A0 = 4'h4; A1 = 4'h4;
            A2 = 4'h4; A3 = 4'h4;

            B0 = 4'h4; B1 = 4'h4;
            B2 = 4'h4; B3 = 4'h4;


            #1;



            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Scalar multiplication", test_num);

            A0 = 4'h1; A1 = 4'h2;
            A2 = 4'h3; A3 = 4'h4;

            B0 = 4'h2; B1 = 4'h0;
            B2 = 4'h0; B3 = 4'h2;


            #1;



            check_outputs(4'h2, 4'h4, 4'h6, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum input values", test_num);

            A0 = 4'hF; A1 = 4'hF;
            A2 = 4'hF; A3 = 4'hF;

            B0 = 4'hF; B1 = 4'hF;
            B2 = 4'hF; B3 = 4'hF;



            #1;




            check_outputs(4'h2, 4'h2, 4'h2, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asymmetric values", test_num);

            A0 = 4'h1; A1 = 4'h0;
            A2 = 4'h5; A3 = 4'h2;

            B0 = 4'h3; B1 = 4'h4;
            B2 = 4'h0; B3 = 4'h6;





            #1;






            check_outputs(4'h3, 4'h4, 4'hF, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiply Testbench");
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
        input [3:0] expected_C0;
        input [3:0] expected_C1;
        input [3:0] expected_C2;
        input [3:0] expected_C3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C0 === (expected_C0 ^ C0 ^ expected_C0) &&
                expected_C1 === (expected_C1 ^ C1 ^ expected_C1) &&
                expected_C2 === (expected_C2 ^ C2 ^ expected_C2) &&
                expected_C3 === (expected_C3 ^ C3 ^ expected_C3)) begin
                $display("PASS");
                $display("  Outputs: C0=%h, C1=%h, C2=%h, C3=%h",
                         C0, C1, C2, C3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C0=%h, C1=%h, C2=%h, C3=%h",
                         expected_C0, expected_C1, expected_C2, expected_C3);
                $display("  Got:      C0=%h, C1=%h, C2=%h, C3=%h",
                         C0, C1, C2, C3);
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
