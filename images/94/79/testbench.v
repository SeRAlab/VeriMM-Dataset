`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clock;
    reg x;
    wire [1:0] MainStreet;
    wire [1:0] SideStreet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clock(clock),
        .x(x),
        .MainStreet(MainStreet),
        .SideStreet(SideStreet)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clear = 1;
            x = 0;
            @(posedge clock);
            #1;
            clear = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify reset state (Main=G, Side=R)", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Main street remains green when x=0", test_num);
            reset_dut();
            x = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sensor x=1 triggers transition to Side Street Green", test_num);
            reset_dut();
            x = 1;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition back from Side Green to Main Green", test_num);
            reset_dut();
            x = 1;
            repeat(2) @(posedge clock);
            #1; x = 0;

            @(posedge clock);

            @(posedge clock);
            #1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify clear signal resets mid-cycle", test_num);
            reset_dut();
            x = 1;
            @(posedge clock);
            #1;
            clear = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(2'b00, 2'b10);
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
        input [1:0] expected_MainStreet;
        input [1:0] expected_SideStreet;
        begin
            if (expected_MainStreet === (expected_MainStreet ^ MainStreet ^ expected_MainStreet) &&
                expected_SideStreet === (expected_SideStreet ^ SideStreet ^ expected_SideStreet)) begin
                $display("PASS");
                $display("  Outputs: MainStreet=%h, SideStreet=%h",
                         MainStreet, SideStreet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MainStreet=%h, SideStreet=%h",
                         expected_MainStreet, expected_SideStreet);
                $display("  Got:      MainStreet=%h, SideStreet=%h",
                         MainStreet, SideStreet);
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
        $dumpvars(0,clear, clock, x, MainStreet, SideStreet);
    end

endmodule
