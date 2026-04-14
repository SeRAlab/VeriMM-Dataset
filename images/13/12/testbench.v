`timescale 1ns/1ps

module dct_4point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [9:0] y0;
    wire [9:0] y1;
    wire [9:0] y2;
    wire [9:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dct_4point dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        x0 = 8'sd0; x1 = 8'sd0; x2 = 8'sd0; x3 = 8'sd0;
        #1;

        check_outputs(10'sd0, 10'sd0, 10'sd0, 10'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: DC Component Positive", test_num);


        x0 = 8'sd20; x1 = 8'sd20; x2 = 8'sd20; x3 = 8'sd20;
        #1;

        check_outputs(10'sd80, 10'sd0, 10'sd0, 10'sd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: DC Component Negative", test_num);

        x0 = -8'sd20; x1 = -8'sd20; x2 = -8'sd20; x3 = -8'sd20;
        #1;

        check_outputs(-10'sd80, 10'sd0, 10'sd0, 10'sd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Pure y1 Frequency", test_num);

        x0 = 8'sd20; x1 = 8'sd10; x2 = -8'sd10; x3 = -8'sd20;




        #1;





        check_outputs(10'sd0, 10'sd100, 10'sd0, 10'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Pure y2 Frequency", test_num);
        x0 = 8'sd10; x1 = -8'sd10; x2 = -8'sd10; x3 = 8'sd10;




        #1;





        check_outputs(10'sd0, 10'sd0, 10'sd40, 10'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Pure y3 Frequency", test_num);
        x0 = 8'sd10; x1 = -8'sd20; x2 = 8'sd20; x3 = -8'sd10;




        #1;





        check_outputs(10'sd0, 10'sd0, 10'sd0, 10'sd100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Impulse Input at x0", test_num);
        x0 = 8'sd20; x1 = 8'sd0; x2 = 8'sd0; x3 = 8'sd0;


        #1;



        check_outputs(10'sd20, 10'sd40, 10'sd20, 10'sd20);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Mixed Input", test_num);
        x0 = 8'sd15; x1 = -8'sd5; x2 = 8'sd10; x3 = 8'sd0;




        #1;





        check_outputs(10'sd20, 10'sd15, 10'sd10, 10'sd45);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dct_4point Testbench");
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
        input [9:0] expected_y0;
        input [9:0] expected_y1;
        input [9:0] expected_y2;
        input [9:0] expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h, y2=%h, y3=%h",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
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
