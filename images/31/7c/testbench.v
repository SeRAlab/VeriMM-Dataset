`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] vec_a;
    reg [4:0] vec_b;
    wire [10:0] dot_product;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .vec_a(vec_a),
        .vec_b(vec_b),
        .dot_product(dot_product),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            vec_a = 5'd0;
            vec_b = 5'd0;
            #1;

            check_outputs(11'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vector A is Zero", test_num);
            vec_a = 5'd0;
            vec_b = 5'd31;
            #1;

            check_outputs(11'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vector B is Zero", test_num);
            vec_a = 5'd15;
            vec_b = 5'd0;
            #1;

            check_outputs(11'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (1x1)", test_num);
            vec_a = 5'd1;
            vec_b = 5'd1;
            #1;

            check_outputs(11'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Values (5x10)", test_num);
            vec_a = 5'd5;
            vec_b = 5'd10;
            #1;

            check_outputs(11'd50, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Values (25x4)", test_num);
            vec_a = 5'd25;
            vec_b = 5'd4;
            #1;

            check_outputs(11'd100, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values (20x20)", test_num);
            vec_a = 5'd20;
            vec_b = 5'd20;
            #1;

            check_outputs(11'd400, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (31x31)", test_num);
            vec_a = 5'd31;
            vec_b = 5'd31;
            #1;

            check_outputs(11'd961, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Numbers (17x13)", test_num);
            vec_a = 5'd17;
            vec_b = 5'd13;
            #1;

            check_outputs(11'd221, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum A with Small B (31x2)", test_num);
            vec_a = 5'd31;
            vec_b = 5'd2;
            #1;

            check_outputs(11'd62, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [10:0] expected_dot_product;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dot_product === (expected_dot_product ^ dot_product ^ expected_dot_product) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dot_product=%h, valid=%b",
                         dot_product, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dot_product=%h, valid=%b",
                         expected_dot_product, expected_valid);
                $display("  Got:      dot_product=%h, valid=%b",
                         dot_product, valid);
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
