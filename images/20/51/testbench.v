`timescale 1ns/1ps

module deserializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [31:0] data_out;
    wire ready_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .data_out(data_out),
        .ready_out(ready_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard 32-bit accumulation", test_num);
            reset_dut();

            @(posedge clk);
            valid_in = 1; data_in = 8'h12; @(posedge clk);
            valid_in = 1; data_in = 8'h34; @(posedge clk);
            valid_in = 1; data_in = 8'h56; @(posedge clk);
            valid_in = 1; data_in = 8'h78;

            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All-Ones pattern", test_num);
            reset_dut();

            @(posedge clk);
            valid_in = 1; data_in = 8'hFF; @(posedge clk);
            valid_in = 1; data_in = 8'hFF; @(posedge clk);
            valid_in = 1; data_in = 8'hFF; @(posedge clk);
            valid_in = 1; data_in = 8'hFF;

            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Intermittent valid_in", test_num);
            reset_dut();

            @(posedge clk);
            valid_in = 1; data_in = 8'hAA; @(posedge clk);
            valid_in = 0; data_in = 8'h00; @(posedge clk);
            valid_in = 0; data_in = 8'hFF; @(posedge clk);
            valid_in = 1; data_in = 8'hBB; @(posedge clk);
            valid_in = 1; data_in = 8'hCC; @(posedge clk);
            valid_in = 1; data_in = 8'hDD;

            #1;
            #1;

            check_outputs(32'hAABBCCDD, 1'b1);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check ready_out is 0 before completion", test_num);
            reset_dut();

            @(posedge clk);
            valid_in = 1; data_in = 8'h11; @(posedge clk);
            valid_in = 1; data_in = 8'h22; @(posedge clk);
            valid_in = 1; data_in = 8'h33;

            #1;

            #1;


            check_outputs(data_out, 1'b0);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            valid_in = 1; data_in = 8'hDE; @(posedge clk);
            valid_in = 1; data_in = 8'hAD; @(posedge clk);


            rst = 1; @(posedge clk);
            rst = 0;


            valid_in = 1; data_in = 8'hBE; @(posedge clk);
            valid_in = 1; data_in = 8'hEF; @(posedge clk);
            valid_in = 1; data_in = 8'hCA; @(posedge clk);
            valid_in = 1; data_in = 8'hFE;

            #1;
            #1;

            check_outputs(32'hBEEFCAFE, 1'b1);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_32bit Testbench");
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
        input expected_ready_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready_out === (expected_ready_out ^ ready_out ^ expected_ready_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready_out=%b",
                         data_out, ready_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready_out=%b",
                         expected_data_out, expected_ready_out);
                $display("  Got:      data_out=%h, ready_out=%b",
                         data_out, ready_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, data_out, ready_out);
    end

endmodule
