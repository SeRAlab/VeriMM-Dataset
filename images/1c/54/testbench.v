`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] b;
    reg [7:0] m;
    reg [7:0] x;
    reg [7:0] y;
    wire class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .b(b),
        .m(m),
        .x(x),
        .y(y),
        .class(class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Line (m=0, b=50), Point (10, 60) - Above", test_num);
            m = 8'd0;
            b = 8'd50;
            x = 8'd10;
            y = 8'd60;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Line (m=0, b=50), Point (10, 40) - Below", test_num);
            m = 8'd0;
            b = 8'd50;
            x = 8'd10;
            y = 8'd40;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Line (m=1, b=0), Point (20, 25) - Above", test_num);
            m = 8'd1;
            b = 8'd0;
            x = 8'd20;
            y = 8'd25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal Line (m=1, b=0), Point (25, 20) - Below", test_num);
            m = 8'd1;
            b = 8'd0;
            x = 8'd25;
            y = 8'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steep Slope (m=2, b=10), Point (5, 25) - Above (2*5+10=20)", test_num);
            m = 8'd2;
            b = 8'd10;
            x = 8'd5;
            y = 8'd25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Steep Slope (m=2, b=10), Point (5, 15) - Below (2*5+10=20)", test_num);
            m = 8'd2;
            b = 8'd10;
            x = 8'd5;
            y = 8'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Intercept (m=1, b=100), Point (10, 120) - Above", test_num);
            m = 8'd1;
            b = 8'd100;
            x = 8'd10;
            y = 8'd120;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Intercept (m=1, b=100), Point (10, 90) - Below", test_num);
            m = 8'd1;
            b = 8'd100;
            x = 8'd10;
            y = 8'd90;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small Offset (m=5, b=2), Point (3, 20) - Above (5*3+2=17)", test_num);
            m = 8'd5;
            b = 8'd2;
            x = 8'd3;
            y = 8'd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small Offset (m=5, b=2), Point (3, 10) - Below (5*3+2=17)", test_num);
            m = 8'd5;
            b = 8'd2;
            x = 8'd3;
            y = 8'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("svm_classifier Testbench");
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
        input expected_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class === (expected_class ^ class ^ expected_class)) begin
                $display("PASS");
                $display("  Outputs: class=%b",
                         class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class=%b",
                         expected_class);
                $display("  Got:      class=%b",
                         class);
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
