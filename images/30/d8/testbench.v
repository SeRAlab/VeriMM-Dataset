`timescale 1ns/1ps

module audio_frame_buffer_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [15:0] audio_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_frame_buffer dut (
        .audio_in(audio_in),
        .clk(clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .audio_out(audio_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            audio_in = 16'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(audio_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Read Cycle", test_num);
            reset_dut();


            @(negedge clk);
            audio_in = 16'hAAAA;
            wr_en = 1;
            @(negedge clk);
            wr_en = 0;


            @(negedge clk);
            rd_en = 1;
            @(negedge clk);
            rd_en = 0;

            #1;

            #1;


            check_outputs(16'hAAAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: FIFO Ordering Check", test_num);
            reset_dut();


            @(negedge clk);
            audio_in = 16'h1111; wr_en = 1;
            @(negedge clk);
            audio_in = 16'h2222; wr_en = 1;
            @(negedge clk);
            wr_en = 0;


            @(negedge clk);
            rd_en = 1;
            @(negedge clk);
            rd_en = 0;

            #1;

            #1;


            check_outputs(16'h1111, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill Buffer until Full", test_num);
            reset_dut();


            @(negedge clk);
            for (i = 0; i < 1024; i = i + 1) begin
                if (!full) begin
                    audio_in = i;
                    wr_en = 1;
                    @(negedge clk);
                end
            end
            wr_en = 0;

            #1;

            #1;


            check_outputs(audio_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Read until Empty", test_num);
            reset_dut();


            @(negedge clk);
            audio_in = 16'h5555; wr_en = 1; @(negedge clk);
            audio_in = 16'h6666; wr_en = 1; @(negedge clk);
            audio_in = 16'h7777; wr_en = 1; @(negedge clk);
            wr_en = 0;


            repeat(3) begin
                @(negedge clk);
                rd_en = 1;
                @(negedge clk);
                rd_en = 0;
            end

            #1;

            #1;


            check_outputs(16'h7777, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_frame_buffer Testbench");
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
        input [15:0] expected_audio_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h, empty=%b, full=%b",
                         audio_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h, empty=%b, full=%b",
                         expected_audio_out, expected_empty, expected_full);
                $display("  Got:      audio_out=%h, empty=%b, full=%b",
                         audio_out, empty, full);
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
        $dumpvars(0,audio_in, clk, rd_en, rst, wr_en, audio_out, empty, full);
    end

endmodule
