`timescale 1ns/1ps

module binary_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] m;
    reg [3:0] n;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_multiplier dut (
        .m(m),
        .n(n),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            m = 4'd0;
            n = 4'd0;
            $display("Test Case %0d: Multiplication by Zero (0 * 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            m = 4'd0;
            n = 4'd15;
            $display("Test Case %0d: Multiplication by Zero (0 * 15)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            m = 4'd1;
            n = 4'd1;
            $display("Test Case %0d: Multiplication by One (1 * 1)", test_num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            m = 4'd1;
            n = 4'd12;
            $display("Test Case %0d: Identity Property (1 * 12)", test_num);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            m = 4'd15;
            n = 4'd1;
            $display("Test Case %0d: Identity Property (15 * 1)", test_num);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            m = 4'd2;
            n = 4'd3;
            $display("Test Case %0d: Simple Multiplication (2 * 3)", test_num);
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            m = 4'd15;
            n = 4'd15;
            $display("Test Case %0d: Maximum Values (15 * 15)", test_num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            m = 4'd10;
            n = 4'd10;
            $display("Test Case %0d: Power of Tens (10 * 10)", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            m = 4'd4;
            n = 4'd8;
            $display("Test Case %0d: Powers of Two (4 * 8)", test_num);
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            m = 4'd7;
            n = 4'd9;
            $display("Test Case %0d: Prime-like Multiplication (7 * 9)", test_num);
            #1;

            check_outputs(8'd63);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            m = 4'd14;
            n = 4'd2;
            $display("Test Case %0d: Large Input A (14 * 2)", test_num);
            #1;

            check_outputs(8'd28);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            m = 4'd3;
            n = 4'd13;
            $display("Test Case %0d: Large Input B (3 * 13)", test_num);
            #1;

            check_outputs(8'd39);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_multiplier Testbench");
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
        input [7:0] expected_product;
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
