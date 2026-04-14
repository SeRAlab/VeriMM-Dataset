`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] cd;
    reg clk;
    reg inframe;
    reg pix;
    wire [9:0] tmds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cd(cd),
        .clk(clk),
        .inframe(inframe),
        .pix(pix),
        .tmds(tmds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cd = 2'b00;
            inframe = 0;
            pix = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            inframe = 0;
            cd = 2'b00;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Control Period (cd=00)", test_num);
            #1;

            check_outputs(10'b1101010100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            inframe = 0;
            cd = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Control Period (cd=01)", test_num);
            #1;

            check_outputs(10'b0010101011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            inframe = 0;
            cd = 2'b10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Control Period (cd=10)", test_num);
            #1;

            check_outputs(10'b0101010101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            inframe = 0;
            cd = 2'b11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Control Period (cd=11)", test_num);
            #1;

            check_outputs(10'b1010101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            inframe = 1;
            pix = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Data Period (pix=0)", test_num);

            #1;


            check_outputs(10'b1000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            inframe = 1;
            pix = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Data Period (pix=1)", test_num);

            #1;


            check_outputs(10'b1011111111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            inframe = 1; pix = 0;
            @(posedge clk);
            #1;

            inframe = 0; cd = 2'b01;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Transition Frame -> Control", test_num);
            #1;

            check_outputs(10'b0010101011);
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
        input [9:0] expected_tmds;
        begin
            if (expected_tmds === (expected_tmds ^ tmds ^ expected_tmds)) begin
                $display("PASS");
                $display("  Outputs: tmds=%h",
                         tmds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tmds=%h",
                         expected_tmds);
                $display("  Got:      tmds=%h",
                         tmds);
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
        $dumpvars(0,cd, clk, inframe, pix, tmds);
    end

endmodule
