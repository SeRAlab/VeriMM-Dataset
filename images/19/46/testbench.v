`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frame_data;
    reg frame_start;
    reg reset;
    reg valid;
    wire [7:0] processed_frame;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_start(frame_start),
        .reset(reset),
        .valid(valid),
        .processed_frame(processed_frame),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frame_start = 0;
            frame_data = 8'h00;
            valid = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 4-byte Frame Transmission", test_num);
            reset_dut();


            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'hAA;
            @(posedge clk);
            #1 frame_start = 0; frame_data = 8'hBB;
            @(posedge clk);
            #1 frame_data = 8'hCC;
            @(posedge clk);
            #1 frame_data = 8'hDD;
            @(posedge clk);
            #1 valid = 0; frame_data = 8'h00;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hDD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Intermittent Valid Signal", test_num);
            reset_dut();

            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'h11;
            @(posedge clk);
            #1 frame_start = 0; valid = 0; frame_data = 8'hFF;
            @(posedge clk);
            #1 valid = 1; frame_data = 8'h22;
            @(posedge clk);
            #1 valid = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Byte Frame", test_num);
            reset_dut();

            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'h55;
            @(posedge clk);
            #1 frame_start = 0; valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-Back Frames", test_num);
            reset_dut();


            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'hA1;
            @(posedge clk);
            #1 frame_start = 0; valid = 0;


            wait(ready == 1'b1);


            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'hB2;
            @(posedge clk);
            #1 frame_start = 0; valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hB2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Operation", test_num);
            reset_dut();

            @(posedge clk);
            #1 frame_start = 1; valid = 1; frame_data = 8'hEE;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;

            repeat(1) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_processed_frame;
        input expected_ready;
        begin
            if (expected_processed_frame === (expected_processed_frame ^ processed_frame ^ expected_processed_frame) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: processed_frame=%h, ready=%b",
                         processed_frame, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: processed_frame=%h, ready=%b",
                         expected_processed_frame, expected_ready);
                $display("  Got:      processed_frame=%h, ready=%b",
                         processed_frame, ready);
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
        $dumpvars(0,clk, frame_data, frame_start, reset, valid, processed_frame, ready);
    end

endmodule
