`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    reg enable;
    wire [9:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .A(A),
        .B(B),
        .enable(enable),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros, enable high", test_num);
            A = 5'b00000;
            B = 5'b00000;
            enable = 1'b1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum overlap (All ones), enable high", test_num);
            A = 5'b11111;
            B = 5'b11111;
            enable = 1'b1;
            #1;

            check_outputs(10'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No overlap (Orthogonal vectors), enable high", test_num);
            A = 5'b10101;
            B = 5'b01010;
            enable = 1'b1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial overlap (LSB and MSB), enable high", test_num);
            A = 5'b10001;
            B = 5'b11111;
            enable = 1'b1;
            #1;

            check_outputs(10'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit overlap (Middle), enable high", test_num);
            A = 5'b00100;
            B = 5'b01110;
            enable = 1'b1;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits overlap, enable high", test_num);
            A = 5'b10101;
            B = 5'b10101;
            enable = 1'b1;
            #1;

            check_outputs(10'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal low check", test_num);

            A = 5'b11111;
            B = 5'b11111;
            enable = 1'b0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex pattern, enable high", test_num);
            A = 5'b11011;
            B = 5'b10111;
            enable = 1'b1;

            #1;


            check_outputs(10'd3);
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
        input [9:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
