`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [7:0] e;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .median(median)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ascending Order", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40; e = 8'd50;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Descending Order", test_num);
            a = 8'd50; b = 8'd40; c = 8'd30; d = 8'd20; e = 8'd10;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Identical", test_num);
            a = 8'd128; b = 8'd128; c = 8'd128; d = 8'd128; e = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Permutation", test_num);
            a = 8'd100; b = 8'd5; c = 8'd250; d = 8'd50; e = 8'd15;

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three identical values (low)", test_num);
            a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd255; e = 8'd255;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three identical values (high)", test_num);
            a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd0; e = 8'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small spread with duplicates", test_num);
            a = 8'd42; b = 8'd17; c = 8'd42; d = 8'd8; e = 8'd42;

            #1;


            check_outputs(8'd42);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large gap", test_num);
            a = 8'd1; b = 8'd2; c = 8'd100; d = 8'd254; e = 8'd255;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex mixture", test_num);
            a = 8'hFF; b = 8'h00; c = 8'hAA; d = 8'h55; e = 8'h80;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two pairs", test_num);
            a = 8'd10; b = 8'd10; c = 8'd50; d = 8'd200; e = 8'd200;

            #1;


            check_outputs(8'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("median_filter Testbench");
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
        input [7:0] expected_median;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_median === (expected_median ^ median ^ expected_median)) begin
                $display("PASS");
                $display("  Outputs: median=%h",
                         median);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: median=%h",
                         expected_median);
                $display("  Got:      median=%h",
                         median);
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
