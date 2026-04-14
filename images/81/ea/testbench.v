`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carry;
    reg clk;
    reg clr;
    reg [3:0] dph;
    reg load;
    reg sft;
    wire [3:0] qph;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry(carry),
        .clk(clk),
        .clr(clr),
        .dph(dph),
        .load(load),
        .sft(sft),
        .qph(qph)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            load = 0;
            sft = 0;
            carry = 0;
            dph = 0;
            @(posedge clk);
            #1;
            clr = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Data 4'b1010", test_num);
            reset_dut();
            load = 1;
            dph = 4'b1010;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right (carry=1) from 0000", test_num);
            reset_dut();
            sft = 1;
            carry = 1;
            @(posedge clk);
            #1;
            sft = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right (carry=0) from 1100", test_num);
            reset_dut();

            load = 1; dph = 4'b1100; @(posedge clk); #1;
            load = 0;

            sft = 1; carry = 0; @(posedge clk); #1;
            sft = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Shifts Sequence", test_num);
            reset_dut();
            sft = 1; carry = 1;
            @(posedge clk);
            carry = 0;
            @(posedge clk);
            carry = 1;
            @(posedge clk);
            #1;
            sft = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority - clr over load", test_num);
            reset_dut();
            clr = 1;
            load = 1;
            dph = 4'b1111;
            @(posedge clk);
            #1;
            clr = 0;
            load = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority - load over sft", test_num);
            reset_dut();
            load = 1;
            dph = 4'b0111;
            sft = 1;
            carry = 1;
            @(posedge clk);
            #1;
            load = 0;
            sft = 0;

            #1;


            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift 4 times with carry=1", test_num);
            reset_dut();
            sft = 1;
            carry = 1;
            repeat(4) @(posedge clk);
            #1;
            sft = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift single bit through register", test_num);
            reset_dut();

            load = 1; dph = 4'b1000; @(posedge clk); #1;
            load = 0;
            sft = 1; carry = 0;
            repeat(3) @(posedge clk);
            #1;
            sft = 0;
            #1;

            check_outputs(4'b0001);
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
        testcase009();
        
        
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
        input [3:0] expected_qph;
        begin
            if (expected_qph === (expected_qph ^ qph ^ expected_qph)) begin
                $display("PASS");
                $display("  Outputs: qph=%h",
                         qph);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qph=%h",
                         expected_qph);
                $display("  Got:      qph=%h",
                         qph);
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
        $dumpvars(0,carry, clk, clr, dph, load, sft, qph);
    end

endmodule
