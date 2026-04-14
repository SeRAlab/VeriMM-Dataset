`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x;
    reg [2:0] y;
    wire [5:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .x(x),
        .y(y),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        x = 3'd1;
        y = 3'd1;
        $display("Test Case %0d: 1 * 1", test_num);
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        x = 3'd0;
        y = 3'd5;
        $display("Test Case %0d: 0 * 5", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        x = 3'd7;
        y = 3'd0;
        $display("Test Case %0d: 7 * 0", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        x = 3'd7;
        y = 3'd7;
        $display("Test Case %0d: 7 * 7 (Max values)", test_num);
        #1;

        check_outputs(6'd49);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        x = 3'd3;
        y = 3'd5;
        $display("Test Case %0d: 3 * 5", test_num);
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        x = 3'd2;
        y = 3'd4;
        $display("Test Case %0d: 2 * 4", test_num);
        #1;

        check_outputs(6'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        x = 3'd6;
        y = 3'd2;
        $display("Test Case %0d: 6 * 2", test_num);
        #1;

        check_outputs(6'd12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        x = 3'd4;
        y = 3'd3;
        $display("Test Case %0d: 4 * 3", test_num);
        #1;

        check_outputs(6'd12);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        x = 3'd1;
        y = 3'd7;
        $display("Test Case %0d: 1 * 7", test_num);
        #1;

        check_outputs(6'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        x = 3'd5;
        y = 3'd5;
        $display("Test Case %0d: 5 * 5", test_num);
        #1;

        check_outputs(6'd25);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [5:0] expected_product;
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
