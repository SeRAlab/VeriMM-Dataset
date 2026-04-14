`timescale 1ns/1ps

module fruit_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] color;
    reg [1:0] size;
    wire [1:0] fruit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fruit_classifier dut (
        .color(color),
        .size(size),
        .fruit(fruit)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Red Small Fruit", test_num);
        color = RED;
        size = SMALL;
        #1;

        check_outputs(APPLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Red Medium Fruit", test_num);
        color = RED;
        size = MEDIUM;
        #1;

        check_outputs(APPLE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Orange Medium Fruit", test_num);
        color = ORANGE_C;
        size = MEDIUM;
        #1;

        check_outputs(ORANGE_F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Orange Large Fruit", test_num);
        color = ORANGE_C;
        size = LARGE;
        #1;

        check_outputs(ORANGE_F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Yellow Large Fruit", test_num);
        color = YELLOW;
        size = LARGE;
        #1;

        check_outputs(BANANA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Yellow Medium Fruit", test_num);
        color = YELLOW;
        size = MEDIUM;
        #1;

        check_outputs(BANANA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fruit_classifier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_fruit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fruit === (expected_fruit ^ fruit ^ expected_fruit)) begin
                $display("PASS");
                $display("  Outputs: fruit=%h",
                         fruit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fruit=%h",
                         expected_fruit);
                $display("  Got:      fruit=%h",
                         fruit);
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
