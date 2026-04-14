`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] payload_data;
    reg [31:0] payload_length;
    reg rst;
    reg start_segment;
    wire done;
    wire [7:0] segment_data;
    wire segment_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .payload_data(payload_data),
        .payload_length(payload_length),
        .rst(rst),
        .start_segment(start_segment),
        .done(done),
        .segment_data(segment_data),
        .segment_valid(segment_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            payload_data = 0;
            payload_length = 0;
            start_segment = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Payload (50 bytes)", test_num);
            reset_dut();

            payload_length = 50;
            start_segment = 1;
            @(posedge clk);
            start_segment = 0;


            for (i = 0; i < 50; i = i + 1) begin
                payload_data = i[7:0];
                if (i == 49) break;
                @(posedge clk);
            end


            wait(done == 1'b1);


            #1;



            check_outputs(1'b1, 8'd49, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Exact MSS Payload (1500 bytes)", test_num);
            reset_dut();

            payload_length = 1500;
            start_segment = 1;
            @(posedge clk);
            start_segment = 0;

            for (i = 0; i < 1500; i = i + 1) begin
                payload_data = (i % 256);
                if (i == 1499) break;
                @(posedge clk);
            end

            wait(done == 1'b1);


            #1;



            check_outputs(1'b1, 8'd219, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Payload over MSS (1501 bytes)", test_num);
            reset_dut();

            payload_length = 1501;
            start_segment = 1;
            @(posedge clk);
            start_segment = 0;

            for (i = 0; i < 1501; i = i + 1) begin
                payload_data = (i % 256);
                if (i == 1500) break;
                @(posedge clk);
            end

            wait(done == 1'b1);


            #1;



            check_outputs(1'b1, 8'd220, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Payload (1 byte)", test_num);
            reset_dut();

            payload_length = 1;
            start_segment = 1;
            payload_data = 8'hAA;
            @(posedge clk);
            start_segment = 0;

            wait(done == 1'b1);

            #1;


            check_outputs(1'b1, 8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Payload (3500 bytes)", test_num);
            reset_dut();

            payload_length = 3500;
            start_segment = 1;
            @(posedge clk);
            start_segment = 0;

            for (i = 0; i < 3500; i = i + 1) begin
                payload_data = (i % 256);
                if (i == 3499) break;
                @(posedge clk);
            end

            wait(done == 1'b1);


            #1;



            check_outputs(1'b1, 8'd171, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [7:0] expected_segment_data;
        input expected_segment_valid;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_segment_data === (expected_segment_data ^ segment_data ^ expected_segment_data) &&
                expected_segment_valid === (expected_segment_valid ^ segment_valid ^ expected_segment_valid)) begin
                $display("PASS");
                $display("  Outputs: done=%b, segment_data=%h, segment_valid=%b",
                         done, segment_data, segment_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, segment_data=%h, segment_valid=%b",
                         expected_done, expected_segment_data, expected_segment_valid);
                $display("  Got:      done=%b, segment_data=%h, segment_valid=%b",
                         done, segment_data, segment_valid);
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
        $dumpvars(0,clk, payload_data, payload_length, rst, start_segment, done, segment_data, segment_valid);
    end

endmodule
