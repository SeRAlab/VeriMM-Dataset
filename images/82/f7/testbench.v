`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [47:0] Din;
    reg EN;
    reg Reset;
    wire [47:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Din(Din),
        .EN(EN),
        .Reset(Reset),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 0;
            EN = 0;
            Din = 0;
            @(negedge Clock);
            Reset = 1;
            @(negedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset initialization", test_num);
            reset_dut();
            #1;

            check_outputs(48'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture data when EN=1", test_num);
            reset_dut();
            @(negedge Clock);
            Din = 48'hAAAA_BBBB_CCCC;
            EN = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'hAAAA_BBBB_CCCC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data capture blocked when EN=0", test_num);
            reset_dut();
            @(negedge Clock);
            Din = 48'h1234_5678_9ABC;
            EN = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Retention of value when EN goes low", test_num);
            reset_dut();


            @(negedge Clock);
            Din = 48'hDEAD_BEEF_CAFE;
            EN = 1;
            @(posedge Clock);


            @(negedge Clock);
            Din = 48'h0000_1111_2222;
            EN = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'hDEAD_BEEF_CAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture maximum 48-bit value", test_num);
            reset_dut();
            @(negedge Clock);
            Din = 48'hFFFF_FFFF_FFFF;
            EN = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'hFFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential capture", test_num);
            reset_dut();

            @(negedge Clock);
            EN = 1;
            Din = 48'h1;
            @(posedge Clock);

            @(negedge Clock);
            Din = 48'h2;
            @(posedge Clock);

            @(negedge Clock);
            Din = 48'h3;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority", test_num);
            reset_dut();

            @(negedge Clock);
            EN = 1;
            Din = 48'h5555_AAAA_5555;
            Reset = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(48'h0);
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
        input [47:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Clock, Din, EN, Reset, Dout);
    end

endmodule
