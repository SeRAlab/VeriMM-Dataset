`timescale 1ns/1ps

module cnn_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_data;
    reg rst;
    wire [15:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cnn_layer dut (
        .clk(clk),
        .input_data(input_data),
        .rst(rst),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_data = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Test Case %03d: All Zeros", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                input_data = 16'h0000;
                @(posedge clk);
            end


            repeat(10) @(posedge clk);


            $display("Checking OFM[0,0]:"); #1;
 check_outputs(16'h0000); @(posedge clk);
            $display("Checking OFM[0,1]:"); #1;
 check_outputs(16'h0000); @(posedge clk);
            $display("Checking OFM[1,0]:"); #1;
 check_outputs(16'h0000); @(posedge clk);
            $display("Checking OFM[1,1]:"); #1;
 check_outputs(16'h0000); @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Test Case %03d: All Ones", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                input_data = 16'h0001;
                @(posedge clk);
            end


            repeat(10) @(posedge clk);


            $display("Checking OFM[0,0]:"); #1;
 check_outputs(16'h0009); @(posedge clk);
            $display("Checking OFM[0,1]:"); #1;
 check_outputs(16'h0009); @(posedge clk);
            $display("Checking OFM[1,0]:"); #1;
 check_outputs(16'h0009); @(posedge clk);
            $display("Checking OFM[1,1]:"); #1;
 check_outputs(16'h0009); @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Test Case %03d: Linear Gradient (1-16)", test_num);
            reset_dut();


            for (i = 1; i <= 16; i = i + 1) begin
                input_data = i;
                @(posedge clk);
            end


            repeat(10) @(posedge clk);

            $display("Checking OFM[0,0]:"); #1;
 check_outputs(16'd54); @(posedge clk);
            $display("Checking OFM[0,1]:"); #1;
 check_outputs(16'd63); @(posedge clk);
            $display("Checking OFM[1,0]:"); #1;
 check_outputs(16'd90); @(posedge clk);
            $display("Checking OFM[1,1]:"); #1;
 check_outputs(16'd99); @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Test Case %03d: Identity Impulse", test_num);
            reset_dut();

            input_data = 16'h0001;
            @(posedge clk);
            for (i = 0; i < 15; i = i + 1) begin
                input_data = 16'h0000;
                @(posedge clk);
            end

            repeat(10) @(posedge clk);

            $display("Checking OFM[0,0]:"); #1;
 check_outputs(16'd1); @(posedge clk);
            $display("Checking OFM[0,1]:"); #1;
 check_outputs(16'd0); @(posedge clk);
            $display("Checking OFM[1,0]:"); #1;
 check_outputs(16'd0); @(posedge clk);
            $display("Checking OFM[1,1]:"); #1;
 check_outputs(16'd0); @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cnn_layer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, rst, output_data);
    end

endmodule
