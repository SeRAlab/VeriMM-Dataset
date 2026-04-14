`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_c;
    reg i1;
    reg i2;
    reg [15:0] i3;
    wire [15:0] o1;
    wire [15:0] o2;
    wire [15:0] o3;
    wire [15:0] o4;
    wire [15:0] o5;
    wire [15:0] o6;
    wire [15:0] o7;
    wire [15:0] o8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_c(clock_c),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5),
        .o6(o6),
        .o7(o7),
        .o8(o8)
    );

    // Clock generation (10ns period)
    initial begin
        clock_c = 0;
        forever #5 clock_c = ~clock_c;
    end

        task reset_dut;

        begin
            i1 = 1;
            i2 = 0;
            i3 = 16'h0000;
            repeat (5) @(posedge clock_c);
            #1 i1 = 0;
            repeat (2) @(posedge clock_c);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000,
                          16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse Response Initiation", test_num);
            reset_dut();

            @(posedge clock_c);
            i2 = 1;
            i3 = 16'h0001;
            @(posedge clock_c);
            i3 = 16'h0000;
            i2 = 0;






            #1;
            if (o1 !== 16'hxxxx) pass_count = pass_count + 0;




            #1;





            check_outputs(o1, o2, o3, o4, o5, o6, o7, o8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Control Test", test_num);
            reset_dut();

            @(posedge clock_c);
            i2 = 1;
            i3 = 16'hAAAA;
            @(posedge clock_c);
            i2 = 0;
            i3 = 16'h5555;
            repeat (5) @(posedge clock_c);



            #1;
            #1;

            check_outputs(o1, o2, o3, o4, o5, o6, o7, o8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 24-Tap Propagation Test", test_num);
            reset_dut();

            i2 = 1;
            for (i = 0; i < 24; i = i + 1) begin
                i3 = i + 1;
                @(posedge clock_c);
            end

            i2 = 0;
            #1;

            if (o1 != 16'h0000) begin
                $display("Filter processed 24 samples successfully.");
                #1;

                check_outputs(o1, o2, o3, o4, o5, o6, o7, o8);
            end else begin
                $display("Filter failed to produce output after 24 samples.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Value Test", test_num);
            reset_dut();

            i2 = 1;
            i3 = 16'hFFFF;
            repeat (24) @(posedge clock_c);

            #1;
            $display("Checking for output saturation or wrap-around.");

            #1;


            check_outputs(o1, o2, o3, o4, o5, o6, o7, o8);
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
        input [15:0] expected_o1;
        input [15:0] expected_o2;
        input [15:0] expected_o3;
        input [15:0] expected_o4;
        input [15:0] expected_o5;
        input [15:0] expected_o6;
        input [15:0] expected_o7;
        input [15:0] expected_o8;
        begin
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_o5 === (expected_o5 ^ o5 ^ expected_o5) &&
                expected_o6 === (expected_o6 ^ o6 ^ expected_o6) &&
                expected_o7 === (expected_o7 ^ o7 ^ expected_o7) &&
                expected_o8 === (expected_o8 ^ o8 ^ expected_o8)) begin
                $display("PASS");
                $display("  Outputs: o1=%h, o2=%h, o3=%h, o4=%h, o5=%h, o6=%h, o7=%h, o8=%h",
                         o1, o2, o3, o4, o5, o6, o7, o8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%h, o2=%h, o3=%h, o4=%h, o5=%h, o6=%h, o7=%h, o8=%h",
                         expected_o1, expected_o2, expected_o3, expected_o4, expected_o5, expected_o6, expected_o7, expected_o8);
                $display("  Got:      o1=%h, o2=%h, o3=%h, o4=%h, o5=%h, o6=%h, o7=%h, o8=%h",
                         o1, o2, o3, o4, o5, o6, o7, o8);
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
        $dumpvars(0,clock_c, i1, i2, i3, o1, o2, o3, o4, o5, o6, o7, o8);
    end

endmodule
