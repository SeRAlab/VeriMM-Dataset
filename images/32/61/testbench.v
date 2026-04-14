`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg enable;
    wire [9:0] Product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A(A),
        .B(B),
        .enable(enable),
        .Product(Product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Enable High)", test_num);
            A = 5'd0;
            B = 5'd0;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (31 * 31)", test_num);
            A = 5'd31;
            B = 5'd31;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd961);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication with Zero (31 * 0)", test_num);
            A = 5'd31;
            B = 5'd0;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Low (Calculations should be gated)", test_num);
            A = 5'd10;
            B = 5'd10;
            enable = 1'b0;
            #10;

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of Two (16 * 4)", test_num);
            A = 5'd16;
            B = 5'd4;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd64);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Values (7 * 13)", test_num);
            A = 5'd7;
            B = 5'd13;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd91);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Result (25 * 25)", test_num);
            A = 5'd25;
            B = 5'd25;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd625);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Values (1 * 1)", test_num);
            A = 5'd1;
            B = 5'd1;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(10'd1);
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
        input [9:0] expected_Product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Product === (expected_Product ^ Product ^ expected_Product)) begin
                $display("PASS");
                $display("  Outputs: Product=%h",
                         Product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Product=%h",
                         expected_Product);
                $display("  Got:      Product=%h",
                         Product);
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
