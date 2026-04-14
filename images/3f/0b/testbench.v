`timescale 1ns/1ps

module tcp_segmentation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [15:0] mss;
    reg reset;
    reg valid_in;
    wire done;
    wire [31:0] segment_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation dut (
        .clk(clk),
        .data_in(data_in),
        .mss(mss),
        .reset(reset),
        .valid_in(valid_in),
        .done(done),
        .segment_out(segment_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 0;
            mss = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Segmentation (4 words, MSS=2)", test_num);
            reset_dut();

            mss = 16'd2;
            @(posedge clk);


            valid_in = 1;
            data_in = 32'h1111_1111; @(posedge clk);
            data_in = 32'h2222_2222; @(posedge clk);
            data_in = 32'h3333_3333; @(posedge clk);
            data_in = 32'h4444_4444; @(posedge clk);
            valid_in = 0;
            data_in = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1, 32'h4444_4444, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Uneven Split (5 words, MSS=2)", test_num);
            reset_dut();

            mss = 16'd2;
            @(posedge clk);

            valid_in = 1;
            data_in = 32'hAAAA_AAAA; @(posedge clk);
            data_in = 32'hBBBB_BBBB; @(posedge clk);
            data_in = 32'hCCCC_CCCC; @(posedge clk);
            data_in = 32'hDDDD_DDDD; @(posedge clk);
            data_in = 32'hEEEE_EEEE; @(posedge clk);
            valid_in = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1, 32'hEEEE_EEEE, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single Short Segment (Data < MSS)", test_num);
            reset_dut();

            mss = 16'd10;
            @(posedge clk);

            valid_in = 1;
            data_in = 32'h0000_0001; @(posedge clk);
            data_in = 32'h0000_0002; @(posedge clk);
            valid_in = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1, 32'h0000_0002, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: One word per segment (MSS=1)", test_num);
            reset_dut();

            mss = 16'd1;
            @(posedge clk);

            valid_in = 1;
            data_in = 32'hF0F0_F0F0; @(posedge clk);
            data_in = 32'hE0E0_E0E0; @(posedge clk);
            data_in = 32'hD0D0_D0D0; @(posedge clk);
            valid_in = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1, 32'hD0D0_D0D0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Intermittent Input Data", test_num);
            reset_dut();

            mss = 16'd2;
            @(posedge clk);

            valid_in = 1; data_in = 32'h1; @(posedge clk);
            valid_in = 0; repeat(2) @(posedge clk);
            valid_in = 1; data_in = 32'h2; @(posedge clk);
            valid_in = 1; data_in = 32'h3; @(posedge clk);
            valid_in = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1, 32'h3, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmentation Testbench");
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
        input [31:0] expected_segment_out;
        input expected_valid_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_segment_out === (expected_segment_out ^ segment_out ^ expected_segment_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, segment_out=%h, valid_out=%b",
                         done, segment_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, segment_out=%h, valid_out=%b",
                         expected_done, expected_segment_out, expected_valid_out);
                $display("  Got:      done=%b, segment_out=%h, valid_out=%b",
                         done, segment_out, valid_out);
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
        $dumpvars(0,clk, data_in, mss, reset, valid_in, done, segment_out, valid_out);
    end

endmodule
