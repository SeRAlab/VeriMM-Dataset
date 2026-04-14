`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg [15:0] w1;
    reg [15:0] w2;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            w1 = 16'h0000;
            x1 = 16'h0000;
            w2 = 16'h0000;
            x2 = 16'h0000;
            b  = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic weighted sum with bias", test_num);

            w1 = 16'd2;
            x1 = 16'd5;
            w2 = 16'd3;
            x2 = 16'd10;
            b  = 16'd15;
            #1;

            check_outputs(32'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only bias term", test_num);

            w1 = 16'd0;
            x1 = 16'd100;
            w2 = 16'd0;
            x2 = 16'd200;
            b  = 16'd500;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large coefficients, zero bias", test_num);

            w1 = 16'd256;
            x1 = 16'd10;
            w2 = 16'd512;
            x2 = 16'd20;
            b  = 16'd0;
            #1;

            check_outputs(32'd12800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: First term zero", test_num);

            w1 = 16'd0;
            x1 = 16'd50;
            w2 = 16'd10;
            x2 = 16'd10;
            b  = 16'd5;
            #1;

            check_outputs(32'd105);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Second term zero", test_num);

            w1 = 16'd10;
            x1 = 16'd10;
            w2 = 16'd0;
            x2 = 16'd50;
            b  = 16'd5;
            #1;

            check_outputs(32'd105);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max input values (Unsigned overflow behavior)", test_num);

            w1 = 16'hFFFF;
            x1 = 16'h0001;
            w2 = 16'h0001;
            x2 = 16'h0001;
            b  = 16'h0001;
            #1;

            check_outputs(32'h00010001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large product near 32-bit limit", test_num);


            w1 = 16'hFFFF;
            x1 = 16'h8000;
            w2 = 16'h0000;
            x2 = 16'h0000;
            b  = 16'h0000;
            #1;

            check_outputs(32'h7FFF8000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Result exceeding 32-bit (Truncation check)", test_num);





            w1 = 16'hFFFF;
            x1 = 16'hFFFF;
            w2 = 16'hFFFF;
            x2 = 16'hFFFF;
            b  = 16'hFFFF;
            #1;

            check_outputs(32'hFFFCFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random small values", test_num);

            w1 = 16'd12;
            x1 = 16'd3;
            w2 = 16'd4;
            x2 = 16'd7;
            b  = 16'd2;
            #1;

            check_outputs(32'h00000042);
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
