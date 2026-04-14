`timescale 1ns/1ps

module knn_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] point_a;
    reg [1:0] point_b;
    wire class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_classifier dut (
        .point_a(point_a),
        .point_b(point_b),
        .class(class)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Point (0,0)", test_num);
        point_a = 2'b00;
        point_b = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Point (3,3)", test_num);
        point_a = 2'b11;
        point_b = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Point (0,3)", test_num);
        point_a = 2'b00;
        point_b = 2'b11;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Point (3,0)", test_num);
        point_a = 2'b11;
        point_b = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Point (1,1)", test_num);
        point_a = 2'b01;
        point_b = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Point (2,2)", test_num);
        point_a = 2'b10;
        point_b = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Point (1,2)", test_num);
        point_a = 2'b01;
        point_b = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Point (2,1)", test_num);
        point_a = 2'b10;
        point_b = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("knn_classifier Testbench");
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
