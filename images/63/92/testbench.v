`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] in1;
    reg reset;
    reg wenable;
    wire [31:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in1(in1),
        .reset(reset),
        .wenable(wenable),
        .out1(out1)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            wenable = 0;
            in1 = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Verify Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Write Enable", test_num);
            reset_dut();
            in1 = 32'hDEADBEEF;
            wenable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Verify Write Enable low ignores input", test_num);
            reset_dut();
            in1 = 32'hCAFEBABE;
            wenable = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Data persistence when wenable is toggled", test_num);
            reset_dut();

            in1 = 32'h12345678;
            wenable = 1;
            @(posedge clock);
            #1;

            in1 = 32'hFFFFFFFF;
            wenable = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Consecutive write cycles", test_num);
            reset_dut();

            in1 = 32'hAAAA_AAAA;
            wenable = 1;
            @(posedge clock);
            #1;

            in1 = 32'h5555_5555;
            wenable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset during active write", test_num);
            reset_dut();

            in1 = 32'hBCBCBCBC;
            wenable = 1;
            @(posedge clock);
            #1;

            if(out1 !== 32'hBCBCBCBC) $display("Intermediate write failed");

            reset = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Toggle all 32 bits", test_num);
            reset_dut();
            in1 = 32'hFFFF_FFFF;
            wenable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_out1;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%h",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h",
                         expected_out1);
                $display("  Got:      out1=%h",
                         out1);
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
        $dumpvars(0,clock, in1, reset, wenable, out1);
    end

endmodule
