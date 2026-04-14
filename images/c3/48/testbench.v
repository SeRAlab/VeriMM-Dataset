`timescale 1ns/1ps

module max_value_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] MAX;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_value dut (
        .A(A),
        .B(B),
        .MAX(MAX)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A is greater than B (A=50, B=10)", test_num);
        A = 8'd50;
        B = 8'd10;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B is greater than A (A=20, B=100)", test_num);
        A = 8'd20;
        B = 8'd100;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: A equals B (A=75, B=75)", test_num);
        A = 8'd75;
        B = 8'd75;
        #1;

        check_outputs(8'd75);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible value vs 0 (A=255, B=0)", test_num);
        A = 8'hFF;
        B = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 vs Maximum possible value (A=0, B=255)", test_num);
        A = 8'h00;
        B = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both inputs are zero", test_num);
        A = 8'd0;
        B = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both inputs are max (255)", test_num);
        A = 8'd255;
        B = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Close values (A=128, B=127)", test_num);
        A = 8'd128;
        B = 8'd127;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Close values (A=127, B=128)", test_num);
        A = 8'd127;
        B = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_value Testbench");
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
        input [7:0] expected_MAX;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MAX === (expected_MAX ^ MAX ^ expected_MAX)) begin
                $display("PASS");
                $display("  Outputs: MAX=%h",
                         MAX);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MAX=%h",
                         expected_MAX);
                $display("  Got:      MAX=%h",
                         MAX);
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
