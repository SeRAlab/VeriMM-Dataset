`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 3 * 2", test_num);
        A = 4'd3; B = 4'd2;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 7 * 5", test_num);
        A = 4'd7; B = 4'd5;
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 3 * -2", test_num);
        A = 4'sb0011; B = 4'sb1110;
        #1;

        check_outputs(8'sb11111010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 5 * -4", test_num);
        A = 4'sb0101; B = 4'sb1100;
        #1;

        check_outputs(8'sb11101100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -3 * 2", test_num);
        A = 4'sb1101; B = 4'sb0010;
        #1;

        check_outputs(8'sb11111010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -8 * 1", test_num);
        A = 4'sb1000; B = 4'sb0001;
        #1;

        check_outputs(8'sb11111000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -3 * -2", test_num);
        A = 4'sb1101; B = 4'sb1110;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -8 * -8", test_num);
        A = 4'sb1000; B = 4'sb1000;
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 0 * 5", test_num);
        A = 4'd0; B = 4'd5;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -7 * 0", test_num);
        A = 4'sb1001; B = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 7 * 7", test_num);
        A = 4'd7; B = 4'd7;
        #1;

        check_outputs(8'd49);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -8 * 7", test_num);
        A = 4'sb1000; B = 4'd7;
        #1;

        check_outputs(8'sb11001000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
