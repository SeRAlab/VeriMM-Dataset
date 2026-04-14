`timescale 1ns/1ps

module addsub_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    addsub_8bit dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd20;
            C = 1'b1;
            $display("Test Case 001: Basic Addition (10 + 20)");
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd50;
            B = 8'd10;
            C = 1'b0;
            $display("Test Case 002: Basic Subtraction (50 - 10)");
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF;
            B = 8'h01;
            C = 1'b1;
            $display("Test Case 003: Addition Overflow (255 + 1)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00;
            B = 8'h01;
            C = 1'b0;
            $display("Test Case 004: Subtraction Underflow (0 - 1)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hFF;
            B = 8'hFF;
            C = 1'b1;
            $display("Test Case 005: Max Addition (255 + 255)");
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'hFF;
            C = 1'b0;
            $display("Test Case 006: Max Subtraction (255 - 255)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'd10;
            B = 8'd20;
            C = 1'b0;
            $display("Test Case 007: Negative Result (10 - 20)");
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hA5;
            B = 8'h00;
            C = 1'b1;
            $display("Test Case 008: Identity Addition (A5 + 0)");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h5A;
            B = 8'h00;
            C = 1'b0;
            $display("Test Case 009: Identity Subtraction (5A - 0)");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'd100;
            B = 8'd50;
            C = 1'b1;
            #5;
            C = 1'b0;
            $display("Test Case 010: Control Toggle (100 - 50)");
            #1;

            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("addsub_8bit Testbench");
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
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
