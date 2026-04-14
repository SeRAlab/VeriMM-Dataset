`timescale 1ns/1ps

module audio_sample_buffer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg write_enable;
    wire [15:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_sample_buffer dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_enable(write_enable),
        .data_out(data_out),
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
            write_enable = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 16'hAAAA;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            #1;



            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write 4 samples", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 16'h1111; write_enable = 1; @(posedge clk);
            data_in = 16'h2222; write_enable = 1; @(posedge clk);
            data_in = 16'h3333; write_enable = 1; @(posedge clk);
            data_in = 16'h4444; write_enable = 1; @(posedge clk);
            write_enable = 0;


            #1;



            check_outputs(16'h1111, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill Buffer (8 samples)", test_num);
            reset_dut();

            for(i=1; i<=8; i=i+1) begin
                @(posedge clk);
                data_in = i[15:0];
                write_enable = 1;
            end
            @(posedge clk);
            write_enable = 0;


            #1;



            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Overwrite Oldest (9 samples)", test_num);
            reset_dut();

            for(i=1; i<=9; i=i+1) begin
                @(posedge clk);
                data_in = i[15:0];
                write_enable = 1;
            end
            @(posedge clk);
            write_enable = 0;



            #1;




            check_outputs(16'h0002, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Overwrites (12 samples)", test_num);
            reset_dut();

            for(i=1; i<=12; i=i+1) begin
                @(posedge clk);
                data_in = i[15:0];
                write_enable = 1;
            end
            @(posedge clk);
            write_enable = 0;


            #1;



            check_outputs(16'h0005, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 16'hBEEF; write_enable = 1; @(posedge clk);
            data_in = 16'hCAFE; write_enable = 1; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("\nTestcase %0d: Double Capacity (16 samples)", test_num);
            reset_dut();

            for(i=1; i<=16; i=i+1) begin
                @(posedge clk);
                data_in = i[15:0];
                write_enable = 1;
            end
            @(posedge clk);
            write_enable = 0;


            #1;



            check_outputs(16'h0009, 1'b1);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, reset, write_enable, data_out, valid);
    end

endmodule
