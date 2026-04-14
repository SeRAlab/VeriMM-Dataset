`timescale 1ns/1ps

module a_star_cost_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] g;
    reg [7:0] h;
    wire [7:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_cost dut (
        .enable(enable),
        .g(g),
        .h(h),
        .f(f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition (10 + 20) with Enable=1", test_num);
        enable = 1;
        g = 8'd10;
        h = 8'd20;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Output should hold previous value (30) when Enable=0", test_num);
        enable = 0;
        g = 8'd50;
        h = 8'd50;

        #1;


        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable transition to high (50 + 50)", test_num);
        enable = 1;
        g = 8'd50;
        h = 8'd50;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with overflow (200 + 100)", test_num);
        enable = 1;
        g = 8'd200;
        h = 8'd100;

        #1;


        check_outputs(8'd44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum 8-bit result (127 + 128)", test_num);
        enable = 1;
        g = 8'd127;
        h = 8'd128;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros", test_num);
        enable = 1;
        g = 8'd0;
        h = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple input changes with Enable low then high", test_num);
        enable = 0;
        g = 8'd5; h = 8'd5; #5;
        g = 8'd15; h = 8'd15; #5;
        enable = 1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_cost Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
