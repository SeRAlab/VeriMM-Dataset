`timescale 1ns/1ps

module fft_32_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg valid_in;
    wire [31:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_32_point dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task feed_input;

        input integer mode;
        integer i;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                valid_in = 1;
                if (mode == 0) begin
                    data_in = 32'h0000_0000;
                end else if (mode == 1) begin
                    data_in = (i == 0) ? 32'h0001_0000 : 32'h0000_0000;
                end else if (mode == 2) begin
                    data_in = 32'h0001_0000;
                end
                @(posedge clk);
            end
            valid_in = 0;
            data_in = 0;
        end
        endtask

    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();

            feed_input(0);


            while (!valid_out) @(posedge clk);


            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(32'h0000_0000, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unit Impulse Input x[0]=1", test_num);
            reset_dut();

            feed_input(1);


            while (!valid_out) @(posedge clk);


            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(32'h0001_0000, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DC Signal Input x[n]=1", test_num);
            reset_dut();

            feed_input(2);


            while (!valid_out) @(posedge clk);


            for (i = 0; i < 32; i = i + 1) begin
                if (i == 0)
                    #1;

                    check_outputs(32'h0020_0000, 1'b1);
                else
                    #1;

                    check_outputs(32'h0000_0000, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Recovery", test_num);
            reset_dut();


            valid_in = 1;
            data_in = 32'hFFFF_FFFF;
            repeat (10) @(posedge clk);

            reset_dut();


            feed_input(0);
            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(32'h0000_0000, 1'b1);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_32_point Testbench");
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
        input [31:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, data_out, valid_out);
    end

endmodule
