`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] sel;
    reg x0;
    reg x1;
    reg x2;
    reg x3;
    reg x4;
    reg x5;
    reg x6;
    reg x7;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .x6(x6),
        .x7(x7),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select x0 (000), set x0=0", test_num);
        sel = 3'b000;
        x0=0; x1=1; x2=1; x3=1; x4=1; x5=1; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select x0 (000), set x0=1", test_num);
        sel = 3'b000;
        x0=1; x1=0; x2=0; x3=0; x4=0; x5=0; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select x1 (001), set x1=0", test_num);
        sel = 3'b001;
        x0=1; x1=0; x2=1; x3=1; x4=1; x5=1; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select x1 (001), set x1=1", test_num);
        sel = 3'b001;
        x0=0; x1=1; x2=0; x3=0; x4=0; x5=0; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select x2 (010), set x2=0", test_num);
        sel = 3'b010;
        x0=1; x1=1; x2=0; x3=1; x4=1; x5=1; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select x2 (010), set x2=1", test_num);
        sel = 3'b010;
        x0=0; x1=0; x2=1; x3=0; x4=0; x5=0; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select x3 (011), set x3=0", test_num);
        sel = 3'b011;
        x0=1; x1=1; x2=1; x3=0; x4=1; x5=1; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select x3 (011), set x3=1", test_num);
        sel = 3'b011;
        x0=0; x1=0; x2=0; x3=1; x4=0; x5=0; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Select x4 (100), set x4=0", test_num);
        sel = 3'b100;
        x0=1; x1=1; x2=1; x3=1; x4=0; x5=1; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Select x4 (100), set x4=1", test_num);
        sel = 3'b100;
        x0=0; x1=0; x2=0; x3=0; x4=1; x5=0; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Select x5 (101), set x5=0", test_num);
        sel = 3'b101;
        x0=1; x1=1; x2=1; x3=1; x4=1; x5=0; x6=1; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Select x5 (101), set x5=1", test_num);
        sel = 3'b101;
        x0=0; x1=0; x2=0; x3=0; x4=0; x5=1; x6=0; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: Select x6 (110), set x6=0", test_num);
        sel = 3'b110;
        x0=1; x1=1; x2=1; x3=1; x4=1; x5=1; x6=0; x7=1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: Select x6 (110), set x6=1", test_num);
        sel = 3'b110;
        x0=0; x1=0; x2=0; x3=0; x4=0; x5=0; x6=1; x7=0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: Select x7 (111), set x7=0", test_num);
        sel = 3'b111;
        x0=1; x1=1; x2=1; x3=1; x4=1; x5=1; x6=1; x7=0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: Select x7 (111), set x7=1", test_num);
        sel = 3'b111;
        x0=0; x1=0; x2=0; x3=0; x4=0; x5=0; x6=0; x7=1;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
