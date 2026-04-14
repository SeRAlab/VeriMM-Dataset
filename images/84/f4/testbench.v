`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_axis_tdata;
    reg input_axis_tlast;
    reg input_axis_tuser;
    reg input_axis_tvalid;
    reg output_axis_tready;
    reg rst;
    wire [2:0] count;
    wire input_axis_tready;
    wire [7:0] output_axis_tdata;
    wire output_axis_tlast;
    wire output_axis_tuser;
    wire output_axis_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_axis_tdata(input_axis_tdata),
        .input_axis_tlast(input_axis_tlast),
        .input_axis_tuser(input_axis_tuser),
        .input_axis_tvalid(input_axis_tvalid),
        .output_axis_tready(output_axis_tready),
        .rst(rst),
        .count(count),
        .input_axis_tready(input_axis_tready),
        .output_axis_tdata(output_axis_tdata),
        .output_axis_tlast(output_axis_tlast),
        .output_axis_tuser(output_axis_tuser),
        .output_axis_tvalid(output_axis_tvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_axis_tdata = 0;
            input_axis_tvalid = 0;
            input_axis_tlast = 0;
            input_axis_tuser = 0;
            output_axis_tready = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state check", test_num);
            reset_dut();

            #1;


            check_outputs(3'd0, 1'b1, 8'h0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single write", test_num);
            reset_dut();
            @(posedge clk);
            input_axis_tdata = 8'hAA;
            input_axis_tvalid = 1;
            input_axis_tlast = 0;
            input_axis_tuser = 1;
            @(posedge clk);
            input_axis_tvalid = 0;

            #1;


            check_outputs(3'd1, 1'b1, 8'hAA, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO (4 elements)", test_num);
            reset_dut();
            @(posedge clk);
            input_axis_tvalid = 1;
            input_axis_tdata = 8'h11; @(posedge clk);
            input_axis_tdata = 8'h22; @(posedge clk);
            input_axis_tdata = 8'h33; @(posedge clk);
            input_axis_tdata = 8'h44; input_axis_tlast = 1; @(posedge clk);
            input_axis_tvalid = 0;
            input_axis_tlast = 0;

            #1;


            check_outputs(3'd4, 1'b0, 8'h11, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read back full FIFO", test_num);
            reset_dut();

            @(posedge clk);
            input_axis_tvalid = 1;
            input_axis_tdata = 8'h01; @(posedge clk);
            input_axis_tdata = 8'h02; @(posedge clk);
            input_axis_tdata = 8'h03; @(posedge clk);
            input_axis_tdata = 8'h04; input_axis_tlast = 1; @(posedge clk);
            input_axis_tvalid = 0; input_axis_tlast = 0;

            output_axis_tready = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            output_axis_tready = 0;

            #1;


            check_outputs(3'd1, 1'b1, 8'h04, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Wrap-around logic", test_num);
            reset_dut();

            @(posedge clk);
            input_axis_tvalid = 1;
            input_axis_tdata = 8'hA1; @(posedge clk);
            input_axis_tdata = 8'hA2; @(posedge clk);
            input_axis_tdata = 8'hA3; @(posedge clk);
            input_axis_tvalid = 0;

            output_axis_tready = 1;
            @(posedge clk);
            @(posedge clk);
            output_axis_tready = 0;

            input_axis_tvalid = 1;
            input_axis_tdata = 8'hB1; @(posedge clk);
            input_axis_tdata = 8'hB2; @(posedge clk);
            input_axis_tvalid = 0;

            #1;


            check_outputs(3'd3, 1'b1, 8'hA3, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();

            @(posedge clk);
            input_axis_tvalid = 1;
            input_axis_tdata = 8'h55;
            @(posedge clk);

            input_axis_tdata = 8'h66;
            input_axis_tvalid = 1;
            output_axis_tready = 1;
            @(posedge clk);
            input_axis_tvalid = 0;
            output_axis_tready = 0;

            #1;


            check_outputs(3'd1, 1'b1, 8'h66, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: FIFO Empty Check", test_num);
            reset_dut();

            @(posedge clk);
            input_axis_tvalid = 1;
            input_axis_tdata = 8'hEE;
            @(posedge clk);
            input_axis_tvalid = 0;

            output_axis_tready = 1;
            @(posedge clk);
            output_axis_tready = 0;

            #1;


            check_outputs(3'd0, 1'b1, 8'h0, 1'b0, 1'b0, 1'b0);
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
        input [2:0] expected_count;
        input expected_input_axis_tready;
        input [7:0] expected_output_axis_tdata;
        input expected_output_axis_tlast;
        input expected_output_axis_tuser;
        input expected_output_axis_tvalid;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_input_axis_tready === (expected_input_axis_tready ^ input_axis_tready ^ expected_input_axis_tready) &&
                expected_output_axis_tdata === (expected_output_axis_tdata ^ output_axis_tdata ^ expected_output_axis_tdata) &&
                expected_output_axis_tlast === (expected_output_axis_tlast ^ output_axis_tlast ^ expected_output_axis_tlast) &&
                expected_output_axis_tuser === (expected_output_axis_tuser ^ output_axis_tuser ^ expected_output_axis_tuser) &&
                expected_output_axis_tvalid === (expected_output_axis_tvalid ^ output_axis_tvalid ^ expected_output_axis_tvalid)) begin
                $display("PASS");
                $display("  Outputs: count=%h, input_axis_tready=%b, output_axis_tdata=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         count, input_axis_tready, output_axis_tdata, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, input_axis_tready=%b, output_axis_tdata=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         expected_count, expected_input_axis_tready, expected_output_axis_tdata, expected_output_axis_tlast, expected_output_axis_tuser, expected_output_axis_tvalid);
                $display("  Got:      count=%h, input_axis_tready=%b, output_axis_tdata=%h, output_axis_tlast=%b, output_axis_tuser=%b, output_axis_tvalid=%b",
                         count, input_axis_tready, output_axis_tdata, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
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
        $dumpvars(0,clk, input_axis_tdata, input_axis_tlast, input_axis_tuser, input_axis_tvalid, output_axis_tready, rst, count, input_axis_tready, output_axis_tdata, output_axis_tlast, output_axis_tuser, output_axis_tvalid);
    end

endmodule
