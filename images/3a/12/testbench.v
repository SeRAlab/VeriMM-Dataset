`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] b;
    reg [3:0] x1;
    reg [3:0] x2;
    wire class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .b(b),
        .x1(x1),
        .x2(x2),
        .class(class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            x1 = 4'sd1; x2 = 4'sd1; b = 4'sd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            x1 = 4'sb1110; x2 = 4'sb1110; b = 4'sd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            x1 = 4'sd0; x2 = 4'sd0; b = 4'sd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            x1 = 4'sb1101; x2 = 4'sd3; b = 4'sd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            x1 = 4'sd1; x2 = 4'sd1; b = 4'sb1001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            x1 = 4'sd7; x2 = 4'sd7; b = 4'sd7;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            x1 = 4'sb1000; x2 = 4'sb1000; b = 4'sb1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;


            x1 = 4'sb1100; x2 = 4'sb1100; b = 4'sd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;

            x1 = 4'sd2; x2 = 4'sb1111; b = 4'sb1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;

            x1 = 4'sd1; x2 = 4'sd1; b = 4'sb1010;
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
