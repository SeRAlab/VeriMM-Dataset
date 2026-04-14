`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] c;
    reg [15:0] m;
    reg [15:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .c(c),
        .m(m),
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero (0*0 + 0)", test_num);
        m = 16'd0;
        x = 16'd0;
        c = 16'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Intercept only (0*100 + 50)", test_num);
        m = 16'd0;
        x = 16'd100;
        c = 16'd50;
        #1;

        check_outputs(32'h00000032);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple values (10*5 + 100)", test_num);
        m = 16'd10;
        x = 16'd5;
        c = 16'd100;
        #1;

        check_outputs(32'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large slope (1000*2 + 0)", test_num);
        m = 16'd1000;
        x = 16'd2;
        c = 16'd0;
        #1;

        check_outputs(32'd2000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large 16-bit values (255*255 + 255)", test_num);
        m = 16'd255;
        x = 16'd255;
        c = 16'd255;
        #1;

        check_outputs(32'd65280);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max product (FFFF * FFFF + 0)", test_num);
        m = 16'hFFFF;
        x = 16'hFFFF;
        c = 16'h0000;
        #1;

        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max possible values (FFFF * FFFF + FFFF)", test_num);
        m = 16'hFFFF;
        x = 16'hFFFF;
        c = 16'hFFFF;
        #1;

        check_outputs(32'hFFFEFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unit slope (1*5000 + 1)", test_num);
        m = 16'd1;
        x = 16'd5000;
        c = 16'd1;
        #1;

        check_outputs(32'd5001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
