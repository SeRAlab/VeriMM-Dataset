`timescale 1ns/1ps

module dwt_filter_bank_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [7:0] approx_out;
    wire [7:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_filter_bank dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .approx_out(approx_out),
        .detail_out(detail_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'd0; @(posedge clk);
            data_in = 8'd0; @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Constant DC Input", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'd128; @(posedge clk);
            data_in = 8'd128; @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd128, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step Input Low-to-High", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'd0;   @(posedge clk);
            data_in = 8'd200; @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h64, 8'h9C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Step Input High-to-Low", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'd200; @(posedge clk);
            data_in = 8'd0;   @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h64, 8'h64);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse Input", test_num);
            reset_dut();
            valid = 1;
            data_in = 8'd255; @(posedge clk);
            data_in = 8'd0;   @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd127, 8'd127);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_filter_bank Testbench");
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
        input [7:0] expected_approx_out;
        input [7:0] expected_detail_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h",
                         expected_approx_out, expected_detail_out);
                $display("  Got:      approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
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
        $dumpvars(0,clk, data_in, reset, valid, approx_out, detail_out);
    end

endmodule
