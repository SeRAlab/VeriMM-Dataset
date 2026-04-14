`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [67:0] Din;
    wire [67:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Din(Din),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            Din = 68'd0;
            repeat(3) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Checking propagation of All-Ones (68'hF...F)", test_num);


            Din = 68'hFFFFFFFFFFFFFFFFF;


            repeat(2) @(posedge CLK);
            #2;

            #1;


            check_outputs(68'hFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Checking pipeline sequence (First value in sequence)", test_num);


            Din = 68'hAAAAAAAAAAAAAAAAA;
            @(posedge CLK);
            #1;
            Din = 68'h55555555555555555;




            @(posedge CLK);
            #2;



            #1;




            check_outputs(68'hAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Checking sequence persistence (Second value in sequence)", test_num);

            Din = 68'h123456789ABCDEF01;
            @(posedge CLK);
            #1;
            Din = 68'hFEDCBA9876543210F;
            @(posedge CLK);
            #1;
            Din = 68'h00000000000000000;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(68'hFEDCBA9876543210F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Checking MSB and LSB transition", test_num);


            Din = (68'h1 << 67) | 68'h1;
            repeat(2) @(posedge CLK);
            #2;

            #1;


            check_outputs((68'h1 << 67) | 68'h1);
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
        input [67:0] expected_Dout;
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
        $dumpvars(0,CLK, Din, Dout);
    end

endmodule
