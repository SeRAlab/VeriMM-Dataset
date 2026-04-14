`timescale 1ns/1ps

module binary_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by zero (0 * 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by zero (255 * 0)", test_num);
        a = 8'hFF;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity element (255 * 1)", test_num);
        a = 8'hFF;
        b = 8'd1;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity element (1 * 128)", test_num);
        a = 8'd1;
        b = 8'd128;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum values (255 * 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Powers of two (16 * 8)", test_num);
        a = 8'd16;
        b = 8'd8;
        #1;

        check_outputs(16'd128);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small values (12 * 11)", test_num);
        a = 8'd12;
        b = 8'd11;
        #1;

        check_outputs(16'd132);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range values (128 * 2)", test_num);
        a = 8'd128;
        b = 8'd2;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large values (200 * 50)", test_num);
        a = 8'd200;
        b = 8'd50;
        #1;

        check_outputs(16'd10000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Prime numbers (17 * 19)", test_num);
        a = 8'd17;
        b = 8'd19;
        #1;

        check_outputs(16'd323);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_multiplier Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
