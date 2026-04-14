`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg segment;
    wire [15:0] segment1;
    wire [15:0] segment2;
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
        .segment(segment),
        .segment1(segment1),
        .segment2(segment2),
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
            segment = 0;
            data_in = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Segmentation", test_num);
            reset_dut();

            data_in = 32'h12345678;
            segment = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 16'h5678, 1'b1);
            segment = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Zeros Data", test_num);
            reset_dut();

            data_in = 32'h00000000;
            segment = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000, 1'b1);
            segment = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Ones Data", test_num);
            reset_dut();

            data_in = 32'hFFFFFFFF;
            segment = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 1'b1);
            segment = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Patterned Data", test_num);
            reset_dut();

            data_in = 32'hAAAA5555;
            segment = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 16'h5555, 1'b1);
            segment = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Segment Signal Not Asserted", test_num);
            reset_dut();

            data_in = 32'hCAFEFACE;
            segment = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(segment1, segment2, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sequential Segmentation Commands", test_num);
            reset_dut();


            data_in = 32'h11112222;
            segment = 1;
            @(posedge clk);
            #1;


            data_in = 32'h33334444;
            segment = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h3333, 16'h4444, 1'b1);
            segment = 0;
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
        input [15:0] expected_segment1;
        input [15:0] expected_segment2;
        input expected_valid;
        begin
            if (expected_segment1 === (expected_segment1 ^ segment1 ^ expected_segment1) &&
                expected_segment2 === (expected_segment2 ^ segment2 ^ expected_segment2) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: segment1=%h, segment2=%h, valid=%b",
                         segment1, segment2, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment1=%h, segment2=%h, valid=%b",
                         expected_segment1, expected_segment2, expected_valid);
                $display("  Got:      segment1=%h, segment2=%h, valid=%b",
                         segment1, segment2, valid);
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
        $dumpvars(0,clk, data_in, reset, segment, segment1, segment2, valid);
    end

endmodule
