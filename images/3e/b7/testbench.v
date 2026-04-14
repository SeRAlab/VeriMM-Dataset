`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] msg_in;
    reg rst;
    reg start;
    wire [7:0] codeword_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .msg_in(msg_in),
        .rst(rst),
        .start(start),
        .codeword_out(codeword_out),
        .done(done)
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
            msg_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Message", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            msg_in = 8'h00; @(posedge clk);
            start = 0;
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h00; @(posedge clk);


            wait(done);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB Unit Message [1,0,0,0]", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            msg_in = 8'h01; @(posedge clk);
            start = 0;
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h00; @(posedge clk);

            wait(done);

            #1;


            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LSB Unit Message [0,0,0,1]", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            msg_in = 8'h00; @(posedge clk);
            start = 0;
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h00; @(posedge clk);
            msg_in = 8'h01; @(posedge clk);

            wait(done);

            #1;


            check_outputs(8'h05, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Message [1,2,3,4]", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            msg_in = 8'h01; @(posedge clk);
            start = 0;
            msg_in = 8'h02; @(posedge clk);
            msg_in = 8'h03; @(posedge clk);
            msg_in = 8'h04; @(posedge clk);

            wait(done);

            #1;


            check_outputs(8'h01, 1'b1);
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
        input [7:0] expected_codeword_out;
        input expected_done;
        begin
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h, done=%b",
                         codeword_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h, done=%b",
                         expected_codeword_out, expected_done);
                $display("  Got:      codeword_out=%h, done=%b",
                         codeword_out, done);
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
        $dumpvars(0,clk, msg_in, rst, start, codeword_out, done);
    end

endmodule
