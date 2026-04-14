`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_ip;
    reg rclk;
    reg read;
    reg reset;
    reg wclk;
    wire audio_irq;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_ip(audio_ip),
        .rclk(rclk),
        .read(read),
        .reset(reset),
        .wclk(wclk),
        .audio_irq(audio_irq),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        rclk = 0;
        forever #5 rclk = ~rclk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_ip = 0;
            read = 0;
            repeat(5) @(posedge wclk);
            reset = 0;
            repeat(2) @(posedge wclk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Fill and read one buffer...");
            test_num = 1;
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                @(posedge wclk);
                audio_ip = i[15:0];
            end


            wait(audio_irq == 1);


            for (i = 0; i < 100; i = i + 1) begin
                @(posedge rclk);
                read = 1;
            end
            @(posedge rclk);
            read = 0;



            #1;




            check_outputs(audio_irq, 16'd99);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Interleaved buffer access...");
            test_num = 2;
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                @(posedge wclk);
                audio_ip = i[15:0];
            end


            fork
                begin : write_process
                    for (i = 100; i < 200; i = i + 1) begin
                        @(posedge wclk);
                        audio_ip = i[15:0];
                    end
                end
                begin : read_process
                    wait(audio_irq == 1);
                    for (i = 0; i < 100; i = i + 1) begin
                        @(posedge rclk);
                        read = 1;
                    end
                    @(posedge rclk);
                    read = 0;
                end
            join



            wait(audio_irq == 1);
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge rclk);
                read = 1;
            end
            @(posedge rclk);
            read = 0;


            #1;



            check_outputs(audio_irq, 16'd199);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        
        
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
        input expected_audio_irq;
        input [15:0] expected_audio_out;
        begin
            if (expected_audio_irq === (expected_audio_irq ^ audio_irq ^ expected_audio_irq) &&
                expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_irq=%b, audio_out=%h",
                         audio_irq, audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_irq=%b, audio_out=%h",
                         expected_audio_irq, expected_audio_out);
                $display("  Got:      audio_irq=%b, audio_out=%h",
                         audio_irq, audio_out);
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
        $dumpvars(0,audio_ip, rclk, read, reset, wclk, audio_irq, audio_out);
    end

endmodule
