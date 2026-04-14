`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x0;
    reg [3:0] x1;
    reg [3:0] x2;
    reg [3:0] x3;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros input", test_num);
            x0 = 4'd0; x1 = 4'd0; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Impulse at x0 (h0=1)", test_num);
            x0 = 4'd5; x1 = 4'd0; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Impulse at x1 (h1=2)", test_num);
            x0 = 4'd0; x1 = 4'd5; x2 = 4'd0; x3 = 4'd0;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Impulse at x2 (h2=1)", test_num);
            x0 = 4'd0; x1 = 4'd0; x2 = 4'd5; x3 = 4'd0;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Impulse at x3 (h3=0)", test_num);
            x0 = 4'd0; x1 = 4'd0; x2 = 4'd0; x3 = 4'd15;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max inputs (60 mod 32)", test_num);
            x0 = 4'd15; x1 = 4'd15; x2 = 4'd15; x3 = 4'd15;
            #1;

            check_outputs(5'd28);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random sequence 1", test_num);
            x0 = 4'd2; x1 = 4'd4; x2 = 4'd2; x3 = 4'd10;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output exactly 31", test_num);
            x0 = 4'd7; x1 = 4'd10; x2 = 4'd4; x3 = 4'd0;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output exactly 32 (wraps to 0)", test_num);
            x0 = 4'd8; x1 = 4'd8; x2 = 4'd8; x3 = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-swing sequence", test_num);
            x0 = 4'd1; x1 = 4'd15; x2 = 4'd1; x3 = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [4:0] expected_y;
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
