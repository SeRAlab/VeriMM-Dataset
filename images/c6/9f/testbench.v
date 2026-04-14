`timescale 1ns/1ps

module adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit dut (
        .A(A),
        .B(B),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd0;
            B = 8'd0;
            $display("Test Case %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd255;
            B = 8'd0;
            $display("Test Case %0d: Max A with zero B (255 + 0)", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd0;
            B = 8'd255;
            $display("Test Case %0d: Zero A with max B (0 + 255)", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'd123;
            B = 8'd45;
            $display("Test Case %0d: Normal addition (123 + 45)", test_num);
            #1;

            check_outputs(8'd168);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'd255;
            B = 8'd1;
            $display("Test Case %0d: Single bit overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'd128;
            B = 8'd128;
            $display("Test Case %0d: Mid-point overflow (128 + 128)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h55;
            B = 8'hAA;
            $display("Test Case %0d: Alternating bit patterns (0x55 + 0xAA)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'd255;
            B = 8'd255;
            $display("Test Case %0d: Maximum overflow (255 + 255)", test_num);
            #1;

            check_outputs(8'd254);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h0F;
            B = 8'h01;
            $display("Test Case %0d: Nibble carry (0x0F + 0x01)", test_num);
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'd200;
            B = 8'd100;
            $display("Test Case %0d: Large value addition with wrap (200 + 100)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit Testbench");
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
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
