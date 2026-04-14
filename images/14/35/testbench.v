`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    wire [15:0] out11;
    wire [15:0] out12;
    wire [15:0] out21;
    wire [15:0] out22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out11(out11),
        .out12(out12),
        .out21(out21),
        .out22(out22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Matrix", test_num);



            a = 16'h0001; b = 16'h0000;
            c = 16'h0000; d = 16'h0001;


            #1;



            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Integers (det=1)", test_num);



            a = 16'h0003; b = 16'h0002;
            c = 16'h0001; d = 16'h0001;


            #1;



            check_outputs(16'h0001, 16'hFFFE, 16'hFFFF, 16'h0003);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Integers (det=1) - Case 2", test_num);



            a = 16'h0005; b = 16'h0003;
            c = 16'h0003; d = 16'h0002;


            #1;



            check_outputs(16'h0002, 16'hFFFD, 16'hFFFD, 16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Determinant (det=-1)", test_num);



            a = 16'h0001; b = 16'h0002;
            c = 16'h0001; d = 16'h0001;


            #1;



            check_outputs(16'hFFFF, 16'h0002, 16'h0001, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Inputs (det=1)", test_num);



            a = 16'hFFFD; b = 16'hFFFE;
            c = 16'hFFFC; d = 16'hFFFD;


            #1;



            check_outputs(16'hFFFD, 16'h0002, 16'h0004, 16'hFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Matrix with Larger Determinant (det=-1 variant)", test_num);



            a = 16'h0002; b = 16'h0005;
            c = 16'h0001; d = 16'h0002;


            #1;



            check_outputs(16'hFFFE, 16'h0005, 16'h0001, 16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [15:0] expected_out11;
        input [15:0] expected_out12;
        input [15:0] expected_out21;
        input [15:0] expected_out22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out11 === (expected_out11 ^ out11 ^ expected_out11) &&
                expected_out12 === (expected_out12 ^ out12 ^ expected_out12) &&
                expected_out21 === (expected_out21 ^ out21 ^ expected_out21) &&
                expected_out22 === (expected_out22 ^ out22 ^ expected_out22)) begin
                $display("PASS");
                $display("  Outputs: out11=%h, out12=%h, out21=%h, out22=%h",
                         out11, out12, out21, out22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out11=%h, out12=%h, out21=%h, out22=%h",
                         expected_out11, expected_out12, expected_out21, expected_out22);
                $display("  Got:      out11=%h, out12=%h, out21=%h, out22=%h",
                         out11, out12, out21, out22);
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
