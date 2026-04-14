`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    wire [15:0] l21;
    wire [15:0] u11;
    wire [15:0] u12;
    wire [15:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lu_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .l21(l21),
        .u11(u11),
        .u12(u12),
        .u22(u22)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple decomposition", test_num);
            a11 = 16'd2;
            a12 = 16'd4;
            a21 = 16'd6;
            a22 = 16'd20;




            #1;





            check_outputs(16'd3, 16'd2, 16'd4, 16'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity-like matrix", test_num);
            a11 = 16'd1;
            a12 = 16'd0;
            a21 = 16'd0;
            a22 = 16'd1;




            #1;





            check_outputs(16'd0, 16'd1, 16'd0, 16'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large integers", test_num);
            a11 = 16'd100;
            a12 = 16'd200;
            a21 = 16'd500;
            a22 = 16'd1500;




            #1;





            check_outputs(16'd5, 16'd100, 16'd200, 16'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Integer division truncation", test_num);
            a11 = 16'd3;
            a12 = 16'd5;
            a21 = 16'd10;
            a22 = 16'd25;




            #1;





            check_outputs(16'd3, 16'd3, 16'd5, 16'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Resulting u22 is zero", test_num);
            a11 = 16'd4;
            a12 = 16'd10;
            a21 = 16'd12;
            a22 = 16'd30;




            #1;





            check_outputs(16'd3, 16'd4, 16'd10, 16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High l21 multiplier", test_num);
            a11 = 16'd1;
            a12 = 16'd1;
            a21 = 16'd100;
            a22 = 16'd200;




            #1;





            check_outputs(16'd100, 16'd1, 16'd1, 16'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible values check (Small Scale)", test_num);
            a11 = 16'h00FF;
            a12 = 16'h0002;
            a21 = 16'h01FE;
            a22 = 16'h0008;




            #1;





            check_outputs(16'd2, 16'h00FF, 16'h0002, 16'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lu_decomposition Testbench");
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
        input [15:0] expected_l21;
        input [15:0] expected_u11;
        input [15:0] expected_u12;
        input [15:0] expected_u22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l21=%h, u11=%h, u12=%h, u22=%h",
                         l21, u11, u12, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l21=%h, u11=%h, u12=%h, u22=%h",
                         expected_l21, expected_u11, expected_u12, expected_u22);
                $display("  Got:      l21=%h, u11=%h, u12=%h, u22=%h",
                         l21, u11, u12, u22);
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
