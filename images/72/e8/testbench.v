`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] id;
    reg mode;
    wire ld1;
    wire ld2;
    wire ld3;
    wire ld4;
    wire ld5;
    wire ld6;
    wire ld7;
    wire ld8;
    wire led1;
    wire led2;
    wire led3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .id(id),
        .mode(mode),
        .ld1(ld1),
        .ld2(ld2),
        .ld3(ld3),
        .ld4(ld4),
        .ld5(ld5),
        .ld6(ld6),
        .ld7(ld7),
        .ld8(ld8),
        .led1(led1),
        .led2(led2),
        .led3(led3)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            id = 4'b0000;
            mode = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Inputs Zero", test_num);
            reset_dut();


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mode=1, ID=1011", test_num);
            reset_dut();
            mode = 1;
            id = 4'b1011;
            #10;


            #1;



            check_outputs(0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mode=0, ID=0110", test_num);
            reset_dut();
            mode = 0;
            id = 4'b0110;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ID Bits High", test_num);
            reset_dut();
            mode = 1;
            id = 4'b1111;
            #10;

            #1;


            check_outputs(0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ID Walking Bit", test_num);
            reset_dut();
            mode = 0;
            id = 4'b0001; #10;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);

            id = 4'b0010; #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);

            id = 4'b0100; #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);

            id = 4'b1000; #10;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0);
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
        input expected_ld1;
        input expected_ld2;
        input expected_ld3;
        input expected_ld4;
        input expected_ld5;
        input expected_ld6;
        input expected_ld7;
        input expected_ld8;
        input expected_led1;
        input expected_led2;
        input expected_led3;
        begin
            if (expected_ld1 === (expected_ld1 ^ ld1 ^ expected_ld1) &&
                expected_ld2 === (expected_ld2 ^ ld2 ^ expected_ld2) &&
                expected_ld3 === (expected_ld3 ^ ld3 ^ expected_ld3) &&
                expected_ld4 === (expected_ld4 ^ ld4 ^ expected_ld4) &&
                expected_ld5 === (expected_ld5 ^ ld5 ^ expected_ld5) &&
                expected_ld6 === (expected_ld6 ^ ld6 ^ expected_ld6) &&
                expected_ld7 === (expected_ld7 ^ ld7 ^ expected_ld7) &&
                expected_ld8 === (expected_ld8 ^ ld8 ^ expected_ld8) &&
                expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3)) begin
                $display("PASS");
                $display("  Outputs: ld1=%b, ld2=%b, ld3=%b, ld4=%b, ld5=%b, ld6=%b, ld7=%b, ld8=%b, led1=%b, led2=%b, led3=%b",
                         ld1, ld2, ld3, ld4, ld5, ld6, ld7, ld8, led1, led2, led3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ld1=%b, ld2=%b, ld3=%b, ld4=%b, ld5=%b, ld6=%b, ld7=%b, ld8=%b, led1=%b, led2=%b, led3=%b",
                         expected_ld1, expected_ld2, expected_ld3, expected_ld4, expected_ld5, expected_ld6, expected_ld7, expected_ld8, expected_led1, expected_led2, expected_led3);
                $display("  Got:      ld1=%b, ld2=%b, ld3=%b, ld4=%b, ld5=%b, ld6=%b, ld7=%b, ld8=%b, led1=%b, led2=%b, led3=%b",
                         ld1, ld2, ld3, ld4, ld5, ld6, ld7, ld8, led1, led2, led3);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, id, mode, ld1, ld2, ld3, ld4, ld5, ld6, ld7, ld8, led1, led2, led3);
    end

endmodule
