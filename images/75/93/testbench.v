`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg init;
    reg [63:0] opa;
    reg [31:0] opb;
    reg reset_n;
    reg update;
    wire [63:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .init(init),
        .opa(opa),
        .opb(opb),
        .reset_n(reset_n),
        .update(update),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        init = 0;
        update = 0;
        opa = 0;
        opb = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Simple multiplication with init", test_num);

        opa = 64'd123456;
        opb = 32'd1000;
        init = 1;
        update = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(64'd123456000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Accumulation sequence", test_num);


        opa = 64'd10;
        opb = 32'd5;
        init = 1;
        update = 1;
        @(posedge clk);


        opa = 64'd20;
        opb = 32'd3;
        init = 0;
        update = 1;
        @(posedge clk);


        opa = 64'd100;
        opb = 32'd2;
        init = 0;
        update = 1;
        @(posedge clk);

        #1;

        #1;


        check_outputs(64'd310);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Update signal control (holding value)", test_num);


        opa = 64'hA;
        opb = 32'h2;
        init = 1;
        update = 1;
        @(posedge clk);


        opa = 64'hFF;
        opb = 32'hFF;
        init = 0;
        update = 0;
        @(posedge clk);

        #1;

        #1;


        check_outputs(64'h14);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Large value overflow/truncation", test_num);


        opa = 64'hFFFFFFFFFFFFFFFF;
        opb = 32'd1;
        init = 1;
        update = 1;
        @(posedge clk);


        opa = 64'd1;
        opb = 32'd1;
        init = 0;
        update = 1;
        @(posedge clk);

        #1;

        #1;


        check_outputs(64'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Re-initialization mid-stream", test_num);


        opa = 64'd50;
        opb = 32'd2;
        init = 1;
        update = 1;
        @(posedge clk);


        opa = 64'd7;
        opb = 32'd8;
        init = 1;
        update = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(64'd56);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Reset during operation", test_num);

        opa = 64'd1000;
        opb = 32'd1000;
        init = 1;
        update = 1;
        @(posedge clk);


        reset_n = 0;
        @(posedge clk);
        reset_n = 1;

        #1;
        #1;

        check_outputs(64'd0);
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
        input [63:0] expected_res;
        begin
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
        $dumpvars(0,clk, init, opa, opb, reset_n, update, res);
    end

endmodule
