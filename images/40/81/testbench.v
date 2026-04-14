`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    wire [3:0] send_frame;
    wire [3:0] window_end;
    wire [3:0] window_start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_frame(send_frame),
        .window_end(window_end),
        .window_start(window_start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State after Reset", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0, 4'h3, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Advance frame pointer within window", test_num);
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2, 4'h3, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Single Acknowledgment", test_num);
            reset_dut();

            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);




            #1;





            check_outputs(4'h2, 4'h4, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multiple Acknowledgments", test_num);
            reset_dut();


            repeat(3) begin
                ack = 1;
                @(posedge clk);
            end
            #1 ack = 0;


            #1;



            check_outputs(4'h6, 4'h6, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Window Wrap-around", test_num);
            reset_dut();




            repeat(14) begin
                ack = 1;
                @(posedge clk);
            end
            #1 ack = 0;

            #1;


            check_outputs(4'h1, 4'h1, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Full Rotation", test_num);
            reset_dut();


            repeat(16) begin
                ack = 1;
                @(posedge clk);
            end
            #1 ack = 0;

            #1;


            check_outputs(4'h3, 4'h3, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Window boundary stall", test_num);
            reset_dut();


            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h3, 4'h3, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_send_frame;
        input [3:0] expected_window_end;
        input [3:0] expected_window_start;
        begin
            if (expected_send_frame === (expected_send_frame ^ send_frame ^ expected_send_frame) &&
                expected_window_end === (expected_window_end ^ window_end ^ expected_window_end) &&
                expected_window_start === (expected_window_start ^ window_start ^ expected_window_start)) begin
                $display("PASS");
                $display("  Outputs: send_frame=%h, window_end=%h, window_start=%h",
                         send_frame, window_end, window_start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: send_frame=%h, window_end=%h, window_start=%h",
                         expected_send_frame, expected_window_end, expected_window_start);
                $display("  Got:      send_frame=%h, window_end=%h, window_start=%h",
                         send_frame, window_end, window_start);
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
        $dumpvars(0,ack, clk, reset, send_frame, window_end, window_start);
    end

endmodule
