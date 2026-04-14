`timescale 1ns/1ps

module array_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    array_multiplier dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (0 x 0)", test_num);
        A = 4'd0;
        B = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values (15 x 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Property (10 x 1)", test_num);
        A = 4'd10;
        B = 4'd1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Property (0 x 12)", test_num);
        A = 4'd0;
        B = 4'd12;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Product (2 x 3)", test_num);
        A = 4'd2;
        B = 4'd3;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of Two (4 x 8)", test_num);
        A = 4'd4;
        B = 4'd8;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Product (12 x 13)", test_num);
        A = 4'd12;
        B = 4'd13;
        #1;

        check_outputs(8'd156);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime Numbers (7 x 11)", test_num);
        A = 4'd7;
        B = 4'd11;
        #1;

        check_outputs(8'd77);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reversing Inputs (15 x 2)", test_num);
        A = 4'd15;
        B = 4'd2;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reversing Inputs (2 x 15)", test_num);
        A = 4'd2;
        B = 4'd15;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits (10 x 5)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Near Max (14 x 14)", test_num);
        A = 4'd14;
        B = 4'd14;
        #1;

        check_outputs(8'd196);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("array_multiplier Testbench");
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
