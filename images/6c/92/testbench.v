`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ch_en;
    reg clk;
    reg crdy;
    reg full_empty;
    reg req;
    reg srs;
    reg valid;
    wire en_out;
    wire en_out_l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ch_en(ch_en),
        .clk(clk),
        .crdy(crdy),
        .full_empty(full_empty),
        .req(req),
        .srs(srs),
        .valid(valid),
        .en_out(en_out),
        .en_out_l(en_out_l)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            ch_en = 0;
            srs = 0;
            full_empty = 0;
            req = 0;
            crdy = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: All conditions met (All inputs high)", test_num);
            valid = 1;
            ch_en = 1;
            srs = 1;
            full_empty = 1;
            req = 1;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Valid data missing (valid=0)", test_num);
            valid = 0;
            ch_en = 1;
            srs = 1;
            full_empty = 1;
            req = 1;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Channel disabled (ch_en=0)", test_num);
            valid = 1;
            ch_en = 0;
            srs = 1;
            full_empty = 1;
            req = 1;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: SRS not ready (srs=0)", test_num);
            valid = 1;
            ch_en = 1;
            srs = 0;
            full_empty = 1;
            req = 1;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: FIFO not ready (full_empty=0)", test_num);
            valid = 1;
            ch_en = 1;
            srs = 1;
            full_empty = 0;
            req = 1;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: No request (req=0)", test_num);
            valid = 1;
            ch_en = 1;
            srs = 1;
            full_empty = 1;
            req = 0;
            crdy = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Codec not ready (crdy=0)", test_num);
            valid = 1;
            ch_en = 1;
            srs = 1;
            full_empty = 1;
            req = 1;
            crdy = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: All signals low", test_num);
            valid = 0;
            ch_en = 0;
            srs = 0;
            full_empty = 0;
            req = 0;
            crdy = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_en_out;
        input expected_en_out_l;
        begin
            if (expected_en_out === (expected_en_out ^ en_out ^ expected_en_out) &&
                expected_en_out_l === (expected_en_out_l ^ en_out_l ^ expected_en_out_l)) begin
                $display("PASS");
                $display("  Outputs: en_out=%b, en_out_l=%b",
                         en_out, en_out_l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_out=%b, en_out_l=%b",
                         expected_en_out, expected_en_out_l);
                $display("  Got:      en_out=%b, en_out_l=%b",
                         en_out, en_out_l);
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
        $dumpvars(0,ch_en, clk, crdy, full_empty, req, srs, valid, en_out, en_out_l);
    end

endmodule
