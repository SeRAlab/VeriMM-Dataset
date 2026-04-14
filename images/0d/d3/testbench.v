`timescale 1ns/1ps

module pipeline_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg valid;
    wire [31:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_register dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 32'b0;
        valid = 1'b0;
        repeat(2) @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Data Propagation", test_num);
        reset_dut();


        data_in = 32'hABCD_1234;
        valid = 1'b1;
        @(posedge clk);
        #1;


        data_in = 32'h0;
        valid = 1'b0;
        repeat(6) @(posedge clk);
        #1;


        #1;



        check_outputs(32'hABCD_1234, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Propagation of Invalid Data", test_num);
        reset_dut();

        data_in = 32'h5555_AAAA;
        valid = 1'b0;
        repeat(7) @(posedge clk);
        #1;


        #1;



        check_outputs(32'h5555_AAAA, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Continuous Pipeline Stream", test_num);
        reset_dut();


        data_in = 32'h1; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h2; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h3; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h4; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h5; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h6; valid = 1'b1; @(posedge clk); #1;
        data_in = 32'h7; valid = 1'b1; @(posedge clk); #1;


        #1;



        check_outputs(32'h1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Mid-Propagation", test_num);
        reset_dut();

        data_in = 32'hFFFF_0000;
        valid = 1'b1;
        @(posedge clk); #1;


        repeat(3) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;


        repeat(4) @(posedge clk);
        #1;


        #1;



        check_outputs(32'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Valid Signal", test_num);
        reset_dut();


        data_in = 32'hCAFE_BABE; valid = 1'b1; @(posedge clk); #1;

        data_in = 32'h0; valid = 1'b0; @(posedge clk); #1;

        data_in = 32'hDEAD_BEEF; valid = 1'b1; @(posedge clk); #1;


        repeat(4) @(posedge clk); #1;


        if (data_out === 32'hCAFE_BABE && valid_out === 1'b1) begin

             repeat(2) @(posedge clk); #1;
             #1;

             check_outputs(32'hDEAD_BEEF, 1'b1);
        end else begin
             #1;

             check_outputs(32'hCAFE_BABE, 1'b1);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_register Testbench");
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
        input [31:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid, data_out, valid_out);
    end

endmodule
