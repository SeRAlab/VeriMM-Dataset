`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pixel00;
    reg [3:0] pixel01;
    reg [3:0] pixel10;
    reg [3:0] pixel11;
    wire [3:0] out00;
    wire [3:0] out01;
    wire [3:0] out10;
    wire [3:0] out11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .out00(out00),
        .out01(out01),
        .out10(out10),
        .out11(out11)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            pixel00 = 4'h0;
            pixel01 = 4'h0;
            pixel10 = 4'h0;
            pixel11 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Maximum Values (F)", test_num);
            pixel00 = 4'hF;
            pixel01 = 4'hF;
            pixel10 = 4'hF;
            pixel11 = 4'hF;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Checkerboard Pattern (A and 5)", test_num);
            pixel00 = 4'hA;
            pixel01 = 4'h5;
            pixel10 = 4'h5;
            pixel11 = 4'hA;
            #1;

            check_outputs(4'hA, 4'h5, 4'h5, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Unique Sequential Values", test_num);
            pixel00 = 4'h1;
            pixel01 = 4'h2;
            pixel10 = 4'h3;
            pixel11 = 4'h4;
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Walking Bit Pattern", test_num);
            pixel00 = 4'h1;
            pixel01 = 4'h2;
            pixel10 = 4'h4;
            pixel11 = 4'h8;
            #1;

            check_outputs(4'h1, 4'h2, 4'h4, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Inverse Sequential Values", test_num);
            pixel00 = 4'hE;
            pixel01 = 4'hD;
            pixel10 = 4'hC;
            pixel11 = 4'hB;
            #1;

            check_outputs(4'hE, 4'hD, 4'hC, 4'hB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Random Distribution", test_num);
            pixel00 = 4'h7;
            pixel01 = 4'h3;
            pixel10 = 4'hB;
            pixel11 = 4'h1;
            #1;

            check_outputs(4'h7, 4'h3, 4'hB, 4'h1);
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
        input [3:0] expected_out00;
        input [3:0] expected_out01;
        input [3:0] expected_out10;
        input [3:0] expected_out11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out00 === (expected_out00 ^ out00 ^ expected_out00) &&
                expected_out01 === (expected_out01 ^ out01 ^ expected_out01) &&
                expected_out10 === (expected_out10 ^ out10 ^ expected_out10) &&
                expected_out11 === (expected_out11 ^ out11 ^ expected_out11)) begin
                $display("PASS");
                $display("  Outputs: out00=%h, out01=%h, out10=%h, out11=%h",
                         out00, out01, out10, out11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out00=%h, out01=%h, out10=%h, out11=%h",
                         expected_out00, expected_out01, expected_out10, expected_out11);
                $display("  Got:      out00=%h, out01=%h, out10=%h, out11=%h",
                         out00, out01, out10, out11);
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
