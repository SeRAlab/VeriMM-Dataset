`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk0;
    reg clk1;
    reg clk2;
    reg [1:0] counter_ch;
    reg [31:0] counter_val;
    reg counter_we;
    reg rst;
    wire counter0_OUT;
    wire counter1_OUT;
    wire counter2_OUT;
    wire [31:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk0(clk0),
        .clk1(clk1),
        .clk2(clk2),
        .counter_ch(counter_ch),
        .counter_val(counter_val),
        .counter_we(counter_we),
        .rst(rst),
        .counter0_OUT(counter0_OUT),
        .counter1_OUT(counter1_OUT),
        .counter2_OUT(counter2_OUT),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk0 = 0;
            clk1 = 0;
            clk2 = 0;
            counter_we = 0;
            counter_val = 32'h0;
            counter_ch = 2'b00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Load Value into Counter 0", test_num);
            reset_dut();

            counter_ch = 2'b00;
            counter_val = 32'hDEADBEEF;
            counter_we = 1;
            @(posedge clk);
            #1 counter_we = 0;
            @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 1'b0, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Load Value into Counter 1", test_num);
            reset_dut();

            counter_ch = 2'b01;
            counter_val = 32'hCAFEBABE;
            counter_we = 1;
            @(posedge clk);
            #1 counter_we = 0;
            @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0, 1'b0, 32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Increment Counter 0", test_num);
            reset_dut();


            counter_ch = 2'b00;
            counter_val = 32'd5;
            counter_we = 1;
            @(posedge clk);
            #1 counter_we = 0;


            repeat(2) begin
                #10 clk0 = 1; #10 clk0 = 0;
            end


            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 32'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Increment Counter 2", test_num);
            reset_dut();


            counter_ch = 2'b10;
            counter_val = 32'd100;
            counter_we = 1;
            @(posedge clk);
            #1 counter_we = 0;


            #10 clk2 = 1; #10 clk2 = 0;


            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 32'd101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Channel Selection", test_num);
            reset_dut();


            counter_we = 1;
            counter_ch = 0; counter_val = 32'd10; @(posedge clk);
            counter_ch = 1; counter_val = 32'd20; @(posedge clk);
            counter_ch = 2; counter_val = 32'd30; @(posedge clk);
            #1 counter_we = 0;


            counter_ch = 2'b01;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 32'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Composite Sum Output", test_num);
            reset_dut();


            counter_we = 1;
            counter_ch = 0; counter_val = 32'd100; @(posedge clk);
            counter_ch = 1; counter_val = 32'd200; @(posedge clk);
            counter_ch = 2; counter_val = 32'd300; @(posedge clk);
            #1 counter_we = 0;


            counter_ch = 2'b11;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 32'd600);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Simultaneous Clocking", test_num);
            reset_dut();


            counter_we = 1;
            counter_ch = 0; counter_val = 32'd1; @(posedge clk);
            counter_ch = 1; counter_val = 32'd2; @(posedge clk);
            counter_ch = 2; counter_val = 32'd3; @(posedge clk);
            #1 counter_we = 0;


            #10 clk0 = 1; clk1 = 1; clk2 = 1;
            #10 clk0 = 0; clk1 = 0; clk2 = 0;



            counter_ch = 2'b10;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 32'd4);
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
        input expected_counter0_OUT;
        input expected_counter1_OUT;
        input expected_counter2_OUT;
        input [31:0] expected_counter_out;
        begin
            if (expected_counter0_OUT === (expected_counter0_OUT ^ counter0_OUT ^ expected_counter0_OUT) &&
                expected_counter1_OUT === (expected_counter1_OUT ^ counter1_OUT ^ expected_counter1_OUT) &&
                expected_counter2_OUT === (expected_counter2_OUT ^ counter2_OUT ^ expected_counter2_OUT) &&
                expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         expected_counter0_OUT, expected_counter1_OUT, expected_counter2_OUT, expected_counter_out);
                $display("  Got:      counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
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
        $dumpvars(0,clk, clk0, clk1, clk2, counter_ch, counter_val, counter_we, rst, counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
    end

endmodule
