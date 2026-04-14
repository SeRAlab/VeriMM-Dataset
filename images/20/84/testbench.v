`timescale 1ns/1ps

module aes_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg [127:0] key_in;
    reg rst;
    reg start;
    wire [127:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_fsm dut (
        .clk(clk),
        .data_in(data_in),
        .key_in(key_in),
        .rst(rst),
        .start(start),
        .data_out(data_out),
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
        data_in = 0;
        key_in = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros Input and Key", test_num);
        reset_dut();

        data_in = 128'h00000000000000000000000000000000;
        key_in  = 128'h00000000000000000000000000000000;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        wait(done);
        #1;





        #1;






        check_outputs(128'hb2d05776d634125b290d235c5c0d2979, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: NIST Standard Data Vector", test_num);
        reset_dut();

        data_in = 128'h3243f6a8885a308d313198a2e0370734;
        key_in  = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        #1;


        #1;



        check_outputs(128'h3925841d02dc09fbdc118597196a0b32, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bits Pattern", test_num);
        reset_dut();

        data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        key_in  = 128'h55555555555555555555555555555555;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        #1;


        #1;



        check_outputs(128'h547633e86f874d8969874d896f874d89, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mid-Operation Reset Recovery", test_num);
        reset_dut();

        data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        key_in  = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        @(posedge clk);
        start = 1;
        repeat(2) @(posedge clk);

        rst = 1;
        @(posedge clk);
        rst = 0;


        if (done === 1'b0) begin
            $display("Reset successful, restarting...");
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            #1;
            #1;

            check_outputs(128'he204e38e65893335e204e38e65893335, 1'b1);
        end else begin
            $display("FAIL: Done signal did not clear on reset");
            fail_count = fail_count + 1;
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
        $display("aes_fsm Testbench");
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
        input [127:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, key_in, rst, start, data_out, done);
    end

endmodule
