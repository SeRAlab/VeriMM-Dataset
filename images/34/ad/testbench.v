`timescale 1ns/1ps

module multiplier_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_8bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Multiplication (0 x 0)", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiply by Zero (255 x 0)", test_num);
            A = 8'd255;
            B = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplied by Value (0 x 255)", test_num);
            A = 8'd0;
            B = 8'd255;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Multiplication (1 x 1)", test_num);
            A = 8'd1;
            B = 8'd1;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiply by One (255 x 1)", test_num);
            A = 8'd255;
            B = 8'd1;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One multiplied by Value (1 x 128)", test_num);
            A = 8'd1;
            B = 8'd128;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (255 x 255)", test_num);
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Values (15 x 15)", test_num);
            A = 8'd15;
            B = 8'd15;
            #1;

            check_outputs(16'd225);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of Two (128 x 2)", test_num);
            A = 8'd128;
            B = 8'd2;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Multiplication (100 x 50)", test_num);
            A = 8'd100;
            B = 8'd50;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary near overflow (128 x 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            #1;

            check_outputs(16'd16384);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Prime Factors (17 x 13)", test_num);
            A = 8'd17;
            B = 8'd13;
            #1;

            check_outputs(16'd221);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_8bit Testbench");
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
        testcase011();
        testcase012();
        
        
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
