`timescale 1ns/1ps

module audio_compression_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_sample;
    reg clk;
    reg rst;
    reg valid;
    wire [7:0] encoded_value;
    wire ready;
    wire [3:0] run_length;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compression dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .rst(rst),
        .valid(valid),
        .encoded_value(encoded_value),
        .ready(ready),
        .run_length(run_length)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            audio_sample = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Sample Run", test_num);
            reset_dut();


            audio_sample = 8'hA1;
            valid = 1;
            @(posedge clk);
            #1;


            audio_sample = 8'hB2;
            valid = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hA1, 1'b1, 4'd1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sample Run (Len 5)", test_num);
            reset_dut();


            audio_sample = 8'h55;
            valid = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1;
            end


            audio_sample = 8'h66;
            valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 1'b1, 4'd5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Run Length (Len 15)", test_num);
            reset_dut();


            audio_sample = 8'hFF;
            valid = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                #1;
            end



            audio_sample = 8'h00;
            valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 1'b1, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent Valid Signal", test_num);
            reset_dut();


            audio_sample = 8'hCC;
            valid = 1;
            @(posedge clk); #1;


            valid = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;


            audio_sample = 8'hCC;
            valid = 1;
            @(posedge clk); #1;


            audio_sample = 8'hDD;
            valid = 1;
            @(posedge clk); #1;


            #1;



            check_outputs(8'hCC, 1'b1, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back Runs", test_num);
            reset_dut();


            audio_sample = 8'h11; valid = 1;
            @(posedge clk); #1;


            audio_sample = 8'h22; valid = 1;
            @(posedge clk); #1;



            audio_sample = 8'h33; valid = 1;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h22, 1'b1, 4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compression Testbench");
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
        input [7:0] expected_encoded_value;
        input expected_ready;
        input [3:0] expected_run_length;
        begin
            if (expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length)) begin
                $display("PASS");
                $display("  Outputs: encoded_value=%h, ready=%b, run_length=%h",
                         encoded_value, ready, run_length);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_value=%h, ready=%b, run_length=%h",
                         expected_encoded_value, expected_ready, expected_run_length);
                $display("  Got:      encoded_value=%h, ready=%b, run_length=%h",
                         encoded_value, ready, run_length);
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
        $dumpvars(0,audio_sample, clk, rst, valid, encoded_value, ready, run_length);
    end

endmodule
