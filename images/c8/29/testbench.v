`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd0;
            $display("Test %0d: Zero Case (0 * 0)", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'd255;
            b = 8'd0;
            $display("Test %0d: Multiply by Zero (255 * 0)", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'd1;
            b = 8'd127;
            $display("Test %0d: Identity Case (1 * 127)", test_num);
            #1;

            check_outputs(16'd127);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd20;
            $display("Test %0d: Basic Multiplication (10 * 20)", test_num);
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'd15;
            b = 8'd15;
            $display("Test %0d: Square Case (15 * 15)", test_num);
            #1;

            check_outputs(16'd225);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'd128;
            b = 8'd2;
            $display("Test %0d: Power of Two Case (128 * 2)", test_num);
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'hFF;
            $display("Test %0d: Max Value Case (255 * 255)", test_num);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'd123;
            b = 8'd45;
            $display("Test %0d: Arbitrary Values (123 * 45)", test_num);
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 8'hAA;
            b = 8'h55;
            $display("Test %0d: Patterned Bits (0xAA * 0x55)", test_num);
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 8'd64;
            b = 8'd64;
            $display("Test %0d: Large Product (64 * 64)", test_num);
            #1;

            check_outputs(16'd4096);
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
        input [15:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
