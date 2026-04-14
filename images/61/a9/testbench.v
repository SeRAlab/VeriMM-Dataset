`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic initialization check");
            reset_dut();

            #1;


            check_outputs(8'd0, 8'd1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Stability check over multiple cycles");
            reset_dut();
            repeat(10) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd0, 8'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Logic check during active reset");
            RST = 1;
            repeat(5) @(posedge CLK);
            #1;



            if (dut.reg1 === 8'd0) begin
                $display("Test Case %0d (Reset State): PASS", test_num + 1);
                pass_count = pass_count + 1;
            end else begin
                $display("Test Case %0d (Reset State): FAIL", test_num + 1);
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;


            RST = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd0, 8'd1);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,CLK, RST);
    end

endmodule
