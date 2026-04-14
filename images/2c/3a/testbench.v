`timescale 1ns/1ps

module SVM_Classifier_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] x1;
    reg [7:0] x2;
    wire class_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SVM_Classifier dut (
        .enable(enable),
        .x1(x1),
        .x2(x2),
        .class_out(class_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Enable low (Disabled)", test_num);
        enable = 0;
        x1 = 8'sd10;
        x2 = 8'sd5;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Positive result (x1 > x2)", test_num);
        enable = 1;
        x1 = 8'sd10;
        x2 = 8'sd5;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Negative result (x1 < x2)", test_num);
        enable = 1;
        x1 = 8'sd5;
        x2 = 8'sd10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Boundary condition (x1 == x2)", test_num);
        enable = 1;
        x1 = 8'sd7;
        x2 = 8'sd7;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Maximum separation positive", test_num);
        enable = 1;
        x1 = 8'sd127;
        x2 = -8'sd128;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Maximum separation negative", test_num);
        enable = 1;
        x1 = -8'sd128;
        x2 = 8'sd127;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Smallest positive difference", test_num);
        enable = 1;
        x1 = 8'sd0;
        x2 = -8'sd1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Negative values (Result > 0)", test_num);
        enable = 1;
        x1 = -8'sd5;
        x2 = -8'sd10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Negative values (Result < 0)", test_num);
        enable = 1;
        x1 = -8'sd20;
        x2 = -8'sd15;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Zero inputs", test_num);
        enable = 1;
        x1 = 8'sd0;
        x2 = 8'sd0;

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
        $display("SVM_Classifier Testbench");
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
        input expected_class_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_out === (expected_class_out ^ class_out ^ expected_class_out)) begin
                $display("PASS");
                $display("  Outputs: class_out=%b",
                         class_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_out=%b",
                         expected_class_out);
                $display("  Got:      class_out=%b",
                         class_out);
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
