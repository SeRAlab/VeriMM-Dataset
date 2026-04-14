`timescale 1ns/1ps

module audio_frame_buffer_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg read;
    reg reset;
    reg write;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_frame_buffer dut (
        .audio_in(audio_in),
        .clk(clk),
        .read(read),
        .reset(reset),
        .write(write),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            write = 0;
            read = 0;
            audio_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write/Read", test_num);
            reset_dut();


            audio_in = 16'hAAAA;
            write = 1;
            @(posedge clk);
            #1 write = 0;


            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
            read = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: FIFO Order (Second Item)", test_num);
            reset_dut();


            audio_in = 16'h1111; write = 1; @(posedge clk);
            #1 audio_in = 16'h2222; write = 1; @(posedge clk);
            #1 write = 0;


            read = 1; @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
            read = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill to Capacity", test_num);
            reset_dut();


            audio_in = 16'h0001; write = 1; @(posedge clk);
            #1 audio_in = 16'h0002; write = 1; @(posedge clk);
            #1 audio_in = 16'h0003; write = 1; @(posedge clk);
            #1 audio_in = 16'h0004; write = 1; @(posedge clk);
            #1 write = 0;


            read = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0004);
            read = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Write and Read", test_num);
            reset_dut();


            audio_in = 16'hA5A5; write = 1; @(posedge clk);
            #1 write = 0; read = 1; @(posedge clk);
            #1 read = 0;


            audio_in = 16'h5A5A; write = 1; @(posedge clk);
            #1 write = 0; read = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5A5A);
            read = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Empty Buffer Read", test_num);
            reset_dut();


            read = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000);
            read = 0;
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
        begin
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h",
                         audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h",
                         expected_audio_out);
                $display("  Got:      audio_out=%h",
                         audio_out);
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
        $dumpvars(0,audio_in, clk, read, reset, write, audio_out);
    end

endmodule
