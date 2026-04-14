`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [9:0] dot_product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A(A),
        .B(B),
        .dot_product(dot_product)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            A = 5'b00000;
            B = 5'b00000;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones (Maximum result)", test_num);
            A = 5'b11111;
            B = 5'b11111;
            #1;

            check_outputs(10'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Orthogonal vectors (Complementary)", test_num);
            A = 5'b10101;
            B = 5'b01010;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single bit match at LSB", test_num);
            A = 5'b00001;
            B = 5'b11111;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single bit match at MSB", test_num);
            A = 5'b10000;
            B = 5'b10000;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Partial match (Alternating pattern)", test_num);
            A = 5'b10101;
            B = 5'b11111;
            #1;

            check_outputs(10'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: One vector is zero", test_num);
            A = 5'b11111;
            B = 5'b00000;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mixed pattern calculation", test_num);



            A = 5'b01110;
            B = 5'b11100;
            #1;

            check_outputs(10'd2);
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
        input [9:0] expected_dot_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dot_product === (expected_dot_product ^ dot_product ^ expected_dot_product)) begin
                $display("PASS");
                $display("  Outputs: dot_product=%h",
                         dot_product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dot_product=%h",
                         expected_dot_product);
                $display("  Got:      dot_product=%h",
                         dot_product);
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
