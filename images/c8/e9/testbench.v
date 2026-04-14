`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero addition (0 + 0)", test_num);
            in1 = 8'd0;
            in2 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Small constants (5 + 10)", test_num);
            in1 = 8'd5;
            in2 = 8'd10;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Boundary - Maximum sum (128 + 127)", test_num);
            in1 = 8'd128;
            in2 = 8'd127;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary - Maximum sum (255 + 0)", test_num);
            in1 = 8'd255;
            in2 = 8'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Symmetric inputs (64 + 64)", test_num);
            in1 = 8'd64;
            in2 = 8'd64;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Adding to zero (0 + 100)", test_num);
            in1 = 8'd0;
            in2 = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: High values (200 + 50)", test_num);
            in1 = 8'd200;
            in2 = 8'd50;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Prime numbers (17 + 19)", test_num);
            in1 = 8'd17;
            in2 = 8'd19;
            #1;

            check_outputs(8'd36);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
