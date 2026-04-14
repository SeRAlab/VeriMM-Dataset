`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg segment_enable;
    wire [3:0] segment_num;
    wire [7:0] segment_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .segment_enable(segment_enable),
        .segment_num(segment_num),
        .segment_out(segment_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            segment_enable = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Segment Check", test_num);
            reset_dut();

            data_in = 16'hA5A5;
            segment_enable = 1;
            @(posedge clk);
            #1;
            segment_enable = 0;


            #1;



            check_outputs(4'd0, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-Segment Increment Check", test_num);
            reset_dut();


            data_in = 16'h1111;
            segment_enable = 1;
            @(posedge clk);
            #1;


            data_in = 16'h2222;
            segment_enable = 1;
            @(posedge clk);
            #1;


            data_in = 16'h3333;
            segment_enable = 1;
            @(posedge clk);
            #1;
            segment_enable = 0;


            #1;



            check_outputs(4'd2, 8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid Signal De-assertion Check", test_num);
            reset_dut();


            segment_enable = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;
            segment_enable = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd1, 8'hFF, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Integrity and Sequence Check", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                data_in = (i << 8) | (8'h10 * i);
                segment_enable = 1;
                @(posedge clk);
                #1;
            end
            segment_enable = 0;


            #1;



            check_outputs(4'd4, 8'h40, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation Check", test_num);
            reset_dut();


            repeat(3) begin
                segment_enable = 1;
                @(posedge clk);
                #1;
            end


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            segment_enable = 1;
            data_in = 16'h00CC;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'd0, 8'hCC, 1'b1);
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
        input [3:0] expected_segment_num;
        input [7:0] expected_segment_out;
        input expected_valid;
        begin
            if (expected_segment_num === (expected_segment_num ^ segment_num ^ expected_segment_num) &&
                expected_segment_out === (expected_segment_out ^ segment_out ^ expected_segment_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: segment_num=%h, segment_out=%h, valid=%b",
                         segment_num, segment_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_num=%h, segment_out=%h, valid=%b",
                         expected_segment_num, expected_segment_out, expected_valid);
                $display("  Got:      segment_num=%h, segment_out=%h, valid=%b",
                         segment_num, segment_out, valid);
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
        $dumpvars(0,clk, data_in, reset, segment_enable, segment_num, segment_out, valid);
    end

endmodule
