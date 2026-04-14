`timescale 1ns/1ps

module binary_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [3:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 2'd0; b = 2'd0;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 2'd0; b = 2'd3;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 2'd3; b = 2'd0;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 2'd1; b = 2'd1;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 2'd1; b = 2'd2;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 2'd2; b = 2'd1;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 2'd1; b = 2'd3;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 2'd3; b = 2'd1;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 2'd2; b = 2'd2;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 2'd2; b = 2'd3;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            a = 2'd3; b = 2'd2;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            a = 2'd3; b = 2'd3;
            $write("Test Case %0d: a=%d, b=%d -> ", test_num, a, b);
            #1;

            check_outputs(4'd9);
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
        input [3:0] expected_product;
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
