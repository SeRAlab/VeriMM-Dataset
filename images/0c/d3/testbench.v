`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: 0.0 * 0.0", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: 1.0 * 1.0", test_num);
            A = 8'h10;
            B = 8'h10;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: 0.5 * 0.5", test_num);
            A = 8'h08;
            B = 8'h08;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: 2.5 * 4.0", test_num);
            A = 8'h28;
            B = 8'h40;
            #1;

            check_outputs(16'h0A00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Max Value * 1.0", test_num);
            A = 8'hFF;
            B = 8'h10;
            #1;

            check_outputs(16'h0FF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max Value * Max Value", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: 0.0625 * 0.0625 (Smallest non-zero)", test_num);
            A = 8'h01;
            B = 8'h01;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: 12.0 * 0.75", test_num);
            A = 8'hC0;
            B = 8'h0C;
            #1;

            check_outputs(16'h0900);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
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
        input [15:0] expected_P;
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
