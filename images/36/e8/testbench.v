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
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (1.0 * 1.0)", test_num);
            A = 8'h10;
            B = 8'h10;
            #10;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero multiplication (0.0 * 5.5)", test_num);
            A = 8'h00;
            B = 8'h58;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values (15.9375 * 15.9375)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #10;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integers (2.0 * 3.0)", test_num);
            A = 8'h20;
            B = 8'h30;
            #10;
            #1;

            check_outputs(16'h0600);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fractions (0.5 * 0.5)", test_num);
            A = 8'h08;
            B = 8'h08;
            #10;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large result (10.0 * 10.0)", test_num);
            A = 8'hA0;
            B = 8'hA0;
            #10;
            #1;

            check_outputs(16'h6400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum non-zero (0.0625 * 0.0625)", test_num);
            A = 8'h01;
            B = 8'h01;
            #10;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed values (1.5 * 2.25)", test_num);
            A = 8'h18;
            B = 8'h24;
            #10;
            #1;

            check_outputs(16'h0360);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integer times fraction (4.0 * 0.25)", test_num);
            A = 8'h40;
            B = 8'h04;
            #10;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max fractional part (0.9375 * 0.9375)", test_num);
            A = 8'h0F;
            B = 8'h0F;
            #10;
            #1;

            check_outputs(16'h00E1);
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
