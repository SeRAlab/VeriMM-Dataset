`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    reg start;
    wire done;
    wire [7:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .done(done),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'h0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'h1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'hA;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'h5;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'hF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input expected_done;
        input [7:0] expected_encoded_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, encoded_out=%h",
                         done, encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, encoded_out=%h",
                         expected_done, expected_encoded_out);
                $display("  Got:      done=%b, encoded_out=%h",
                         done, encoded_out);
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
        $dumpvars(0,clk, data_in, rst, start, done, encoded_out);
    end

endmodule
