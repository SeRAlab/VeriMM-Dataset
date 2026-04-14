`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A0;
    reg [7:0] A1;
    reg [7:0] A2;
    reg [7:0] A3;
    reg [7:0] A4;
    reg [7:0] B0;
    reg [7:0] B1;
    reg [7:0] B2;
    reg [7:0] B3;
    reg [7:0] B4;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .B4(B4),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A0 = 8'd0; A1 = 8'd0; A2 = 8'd0; A3 = 8'd0; A4 = 8'd0;
            B0 = 8'd0; B1 = 8'd0; B2 = 8'd0; B3 = 8'd0; B4 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (A * 1)", test_num);
            A0 = 8'd10; A1 = 8'd20; A2 = 8'd30; A3 = 8'd40; A4 = 8'd50;
            B0 = 8'd1;  B1 = 8'd1;  B2 = 8'd1;  B3 = 8'd1;  B4 = 8'd1;

            #1;


            check_outputs(16'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Scaling (A * 2)", test_num);
            A0 = 8'd1; A1 = 8'd2; A2 = 8'd3; A3 = 8'd4; A4 = 8'd5;
            B0 = 8'd2; B1 = 8'd2; B2 = 8'd2; B3 = 8'd2; B4 = 8'd2;

            #1;


            check_outputs(16'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Element Max", test_num);
            A0 = 8'd255; A1 = 8'd0; A2 = 8'd0; A3 = 8'd0; A4 = 8'd0;
            B0 = 8'd255; B1 = 8'd0; B2 = 8'd0; B3 = 8'd0; B4 = 8'd0;

            #1;


            check_outputs(16'hFE01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Small Values", test_num);
            A0 = 8'd12; A1 = 8'd5;  A2 = 8'd8;  A3 = 8'd3;  A4 = 8'd10;
            B0 = 8'd4;  B1 = 8'd10; B2 = 8'd2;  B3 = 8'd15; B4 = 8'd7;


            #1;



            check_outputs(16'd229);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near 16-bit Limit", test_num);
            A0 = 8'd200; A1 = 8'd100; A2 = 8'd50;  A3 = 8'd25;  A4 = 8'd10;
            B0 = 8'd200; B1 = 8'd100; B2 = 8'd50;  B3 = 8'd25;  B4 = 8'd10;

            #1;


            check_outputs(16'd53225);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Symmetric Vectors", test_num);
            A0 = 8'd1;   A1 = 8'd2;   A2 = 8'd3;   A3 = 8'd2;   A4 = 8'd1;
            B0 = 8'd100; B1 = 8'd50;  B2 = 8'd10;  B3 = 8'd50;  B4 = 8'd100;

            #1;


            check_outputs(16'd430);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Zeros", test_num);
            A0 = 8'd255; A1 = 8'd0;   A2 = 8'd255; A3 = 8'd0;   A4 = 8'd255;
            B0 = 8'd0;   B1 = 8'd255; B2 = 8'd0;   B3 = 8'd255; B4 = 8'd0;

            #1;


            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [15:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
