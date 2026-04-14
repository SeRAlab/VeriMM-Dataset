`timescale 1ns/1ps

module fft_8point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] in_data;
    reg rst;
    wire [255:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_8point dut (
        .clk(clk),
        .in_data(in_data),
        .rst(rst),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_data = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();

            in_data = 256'h0;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unit Impulse at n=0", test_num);
            reset_dut();


            in_data = {224'h0, 32'h0001_0000};


            expected = {8{32'h0001_0000}};

            repeat(10) @(posedge clk);

            #1;


            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DC Signal (All ones)", test_num);
            reset_dut();


            in_data = {8{32'h0001_0000}};



            expected = {224'h0, 32'h0008_0000};

            repeat(10) @(posedge clk);

            #1;


            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Imaginary DC Signal", test_num);
            reset_dut();


            in_data = {8{32'h0000_0001}};


            expected = {224'h0, 32'h0000_0008};

            repeat(10) @(posedge clk);

            #1;


            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [255:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unit Impulse at n=4", test_num);
            reset_dut();


            in_data = 256'h0;
            in_data[159:128] = 32'h0001_0000;




            expected = {32'hffff_0000, 32'h0001_0000, 32'hffff_0000, 32'h0001_0000,
                        32'hffff_0000, 32'h0001_0000, 32'hffff_0000, 32'h0001_0000};

            repeat(10) @(posedge clk);

            #1;


            check_outputs(expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_8point Testbench");
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
        input [255:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, rst, out_data);
    end

endmodule
