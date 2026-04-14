`timescale 1ns/1ps

module max_heap_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] max;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_heap dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .max(max)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max at 'd' (Ascending order)", test_num);
            a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max at 'a' (Descending order)", test_num);
            a = 8'hFF; b = 8'hAA; c = 8'h55; d = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max at 'b' (Random order)", test_num);
            a = 8'd45; b = 8'd120; c = 8'd2; d = 8'd88;
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max at 'c' (Random order)", test_num);
            a = 8'd10; b = 8'd20; c = 8'd250; d = 8'd5;
            #1;

            check_outputs(8'd250);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs identical", test_num);
            a = 8'h77; b = 8'h77; c = 8'h77; d = 8'h77;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple identical maximums (a and c)", test_num);
            a = 8'hE0; b = 8'h10; c = 8'hE0; d = 8'h40;
            #1;

            check_outputs(8'hE0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value is 255", test_num);
            a = 8'd254; b = 8'd255; c = 8'd128; d = 8'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit differences at high end", test_num);
            a = 8'b11111110; b = 8'b11111101; c = 8'b11111011; d = 8'b11111111;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum at 'd' with small values", test_num);
            a = 8'd1; b = 8'd2; c = 8'd3; d = 8'd4;
            #1;

            check_outputs(8'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_heap Testbench");
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
        input [7:0] expected_max;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max === (expected_max ^ max ^ expected_max)) begin
                $display("PASS");
                $display("  Outputs: max=%h",
                         max);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h",
                         expected_max);
                $display("  Got:      max=%h",
                         max);
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
