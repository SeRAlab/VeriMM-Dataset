`timescale 1ns/1ps

module tcp_segmentor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg data_valid;
    reg [15:0] mss;
    reg reset;
    wire [127:0] data_out;
    wire done;
    wire segment_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentor dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .mss(mss),
        .reset(reset),
        .data_out(data_out),
        .done(done),
        .segment_valid(segment_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        data_valid = 0;
        mss = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase001: MSS = 128 (Exact match)");
        reset_dut();
        data_in = 128'hA1A1A1A1B2B2B2B2C3C3C3C3D4D4D4D4;
        mss = 16'd128;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;


        while (!done) @(posedge clk);

        #1;

        #1;


        check_outputs(128'hA1A1A1A1B2B2B2B2C3C3C3C3D4D4D4D4, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase002: MSS = 64 (Two equal segments)");
        reset_dut();
        data_in = 128'hFFFFFFFFEEEEEEEE_DDDDCCCCBBBBAAAA;
        mss = 16'd64;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;


        while (!done) @(posedge clk);

        #1;

        #1;


        check_outputs(128'h0000000000000000_DDDDCCCCBBBBAAAA, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase003: MSS = 32 (Four equal segments)");
        reset_dut();
        data_in = 128'h11111111_22222222_33333333_44444444;
        mss = 16'd32;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;

        while (!done) @(posedge clk);

        #1;

        #1;


        check_outputs(128'h00000000000000000000000044444444, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase004: MSS = 256 (MSS > Data Size)");
        reset_dut();
        data_in = 128'hDEADD00DCAFEBABEDEADBEEFCAFEBABE;
        mss = 16'd256;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;

        while (!done) @(posedge clk);

        #1;

        #1;


        check_outputs(128'hDEADD00DCAFEBABEDEADBEEFCAFEBABE, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase005: MSS = 50 (Uneven split: 50, 50, 28)");
        reset_dut();
        data_in = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
        mss = 16'd50;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;

        while (!done) @(posedge clk);

        #1;


        #1;



        check_outputs(128'h00000000_00000000_00000000_0FFFFFFF, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase006: MSS = 8 (Smallest typical segment)");
        reset_dut();
        data_in = 128'h00112233445566778899AABBCCDDEEFF;
        mss = 16'd8;
        data_valid = 1;
        @(posedge clk);
        data_valid = 0;

        while (!done) @(posedge clk);

        #1;

        #1;


        check_outputs(128'h000000000000000000000000000000FF, 1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentor Testbench");
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
        input [127:0] expected_data_out;
        input expected_done;
        input expected_segment_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_segment_valid === (expected_segment_valid ^ segment_valid ^ expected_segment_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b, segment_valid=%b",
                         data_out, done, segment_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b, segment_valid=%b",
                         expected_data_out, expected_done, expected_segment_valid);
                $display("  Got:      data_out=%h, done=%b, segment_valid=%b",
                         data_out, done, segment_valid);
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
        $dumpvars(0,clk, data_in, data_valid, mss, reset, data_out, done, segment_valid);
    end

endmodule
