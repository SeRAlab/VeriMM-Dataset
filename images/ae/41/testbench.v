`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] busin;
    reg clk;
    reg clr;
    reg wa;
    wire [3:0] addrout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .busin(busin),
        .clk(clk),
        .clr(clr),
        .wa(wa),
        .addrout(addrout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            wa = 0;
            busin = 4'b0;
            @(posedge clk);
            #1;
            clr = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write (4'hA)", test_num);
            reset_dut();
            @(negedge clk);
            wa = 1;
            busin = 4'hA;
            @(posedge clk);
            #2;
            wa = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Write Disable Check", test_num);
            reset_dut();
            @(negedge clk);
            wa = 0;
            busin = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Persistence Check", test_num);
            reset_dut();

            @(negedge clk);
            wa = 1;
            busin = 4'h5;
            @(posedge clk);
            #2;

            wa = 0;
            busin = 4'hE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Clear Priority Check", test_num);
            reset_dut();
            @(negedge clk);
            wa = 1;
            clr = 1;
            busin = 4'h7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Writes", test_num);
            reset_dut();
            @(negedge clk);
            wa = 1;
            busin = 4'h1;
            @(posedge clk);
            #1;
            busin = 4'h3;
            @(posedge clk);
            #1;
            busin = 4'h7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Clear after Write", test_num);
            reset_dut();
            @(negedge clk);
            wa = 1;
            busin = 4'hB;
            @(posedge clk);
            #2;
            wa = 0;
            clr = 1;
            @(posedge clk);
            #2;
            clr = 0;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_addrout;
        begin
            if (expected_addrout === (expected_addrout ^ addrout ^ expected_addrout)) begin
                $display("PASS");
                $display("  Outputs: addrout=%h",
                         addrout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addrout=%h",
                         expected_addrout);
                $display("  Got:      addrout=%h",
                         addrout);
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
        $dumpvars(0,busin, clk, clr, wa, addrout);
    end

endmodule
