`timescale 1ns/1ps

module audio_sample_buffer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] sample_in;
    reg wr_en;
    wire [7:0] sample_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_sample_buffer dut (
        .clk(clk),
        .rst(rst),
        .sample_in(sample_in),
        .wr_en(wr_en),
        .sample_out(sample_out)
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
            sample_in = 8'h00;
            #10;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Full Buffer Write");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk); wr_en = 1; sample_in = 8'hA1;
            @(posedge clk); wr_en = 1; sample_in = 8'hB2;
            @(posedge clk); wr_en = 1; sample_in = 8'hC3;
            @(posedge clk); wr_en = 1; sample_in = 8'hD4;
            @(posedge clk); wr_en = 1; sample_in = 8'hE5;
            @(posedge clk); wr_en = 0;

            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Buffer Overflow (6 writes)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk); wr_en = 1; sample_in = 8'h11;
            @(posedge clk); wr_en = 1; sample_in = 8'h22;
            @(posedge clk); wr_en = 1; sample_in = 8'h33;
            @(posedge clk); wr_en = 1; sample_in = 8'h44;
            @(posedge clk); wr_en = 1; sample_in = 8'h55;
            @(posedge clk); wr_en = 1; sample_in = 8'h66;
            @(posedge clk); wr_en = 0;

            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Intermittent Writes");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk); wr_en = 1; sample_in = 8'hAA;
            @(posedge clk); wr_en = 0; sample_in = 8'hFF;
            @(posedge clk); wr_en = 0; sample_in = 8'hFF;
            @(posedge clk); wr_en = 1; sample_in = 8'hBB;
            @(posedge clk); wr_en = 1; sample_in = 8'hCC;
            @(posedge clk); wr_en = 1; sample_in = 8'hDD;
            @(posedge clk); wr_en = 1; sample_in = 8'hEE;
            @(posedge clk); wr_en = 0;

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Heavy Throughput");
            test_num = test_num + 1;
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                wr_en = 1;
                sample_in = i;
            end
            @(posedge clk);
            wr_en = 0;

            #1;



            #1;




            check_outputs(8'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_sample_buffer Testbench");
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
        input [7:0] expected_sample_out;
        begin
            if (expected_sample_out === (expected_sample_out ^ sample_out ^ expected_sample_out)) begin
                $display("PASS");
                $display("  Outputs: sample_out=%h",
                         sample_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sample_out=%h",
                         expected_sample_out);
                $display("  Got:      sample_out=%h",
                         sample_out);
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
        $dumpvars(0,clk, rst, sample_in, wr_en, sample_out);
    end

endmodule
