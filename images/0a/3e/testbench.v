`timescale 1ns/1ps

module multiplier_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg reset;
    reg valid;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_4bit dut (
        .A(A),
        .B(B),
        .reset(reset),
        .valid(valid),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset initialization check", test_num);
        A = 4'd10;
        B = 4'd10;
        valid = 1'b1;
        reset = 1'b1;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic multiplication (3 * 5)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd3;
        B = 4'd5;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by zero (12 * 0)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd12;
        B = 4'd0;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplicative identity (15 * 1)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd15;
        B = 4'd1;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum values (15 * 15)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd15;
        B = 4'd15;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'hE1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Prime numbers multiplication (7 * 13)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd7;
        B = 4'd13;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd91);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power of two multiplication (4 * 8)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd4;
        B = 4'd8;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid signal low check", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd5;
        B = 4'd5;
        valid = 1'b0;
        #10;

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range multiplication (9 * 6)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd9;
        B = 4'd6;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd54);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large number by small number (14 * 2)", test_num);
        reset = 1'b1; #5; reset = 1'b0;
        A = 4'd14;
        B = 4'd2;
        valid = 1'b1;
        #10;
        #1;

        check_outputs(8'd28);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_4bit Testbench");
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
