`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;
    wire [7:0] out5;
    wire [7:0] out6;
    wire [7:0] out7;
    wire [7:0] out8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5),
        .out6(out6),
        .out7(out7),
        .out8(out8)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Distinct values (A=11, B=22, C=33, D=44)", test_num);
            A = 8'h11; B = 8'h22; C = 8'h33; D = 8'h44;

            #1;


            check_outputs(8'h11, 8'h11, 8'h22, 8'h22, 8'h33, 8'h33, 8'h44, 8'h44);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform image (All FF)", test_num);
            A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF;

            #1;


            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Stripe (A,B same; C,D same)", test_num);
            A = 8'hAA; B = 8'hAA; C = 8'h55; D = 8'h55;

            #1;


            check_outputs(8'hAA, 8'hAA, 8'hAA, 8'hAA, 8'h55, 8'h55, 8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Stripe (A,C same; B,D same)", test_num);
            A = 8'hF0; B = 8'h0F; C = 8'hF0; D = 8'h0F;

            #1;


            check_outputs(8'hF0, 8'hF0, 8'h0F, 8'h0F, 8'hF0, 8'hF0, 8'h0F, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard pattern", test_num);
            A = 8'h01; B = 8'hFE; C = 8'hFE; D = 8'h01;

            #1;


            check_outputs(8'h01, 8'h01, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h01, 8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        input [7:0] expected_out5;
        input [7:0] expected_out6;
        input [7:0] expected_out7;
        input [7:0] expected_out8;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5) &&
                expected_out6 === (expected_out6 ^ out6 ^ expected_out6) &&
                expected_out7 === (expected_out7 ^ out7 ^ expected_out7) &&
                expected_out8 === (expected_out8 ^ out8 ^ expected_out8)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         out1, out2, out3, out4, out5, out6, out7, out8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4, expected_out5, expected_out6, expected_out7, expected_out8);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h, out5=%h, out6=%h, out7=%h, out8=%h",
                         out1, out2, out3, out4, out5, out6, out7, out8);
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
