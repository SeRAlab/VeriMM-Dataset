`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg rst;
    wire [7:0] out_data;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .rst(rst),
        .out_data(out_data),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_valid = 0;
            in_data = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Single Sample Conversion (0xA5)", test_num);
            reset_dut();

            @(posedge clk);
            in_valid = 1;
            in_data = 8'hA5;
            @(posedge clk);
            in_valid = 0;
            in_data = 8'h00;


            while (!out_valid) @(posedge clk);

            #1;
            $display("Checking First Output Sample...");
            #1;

            check_outputs(8'hA5, 1'b1);

            @(posedge clk);
            #1;
            $display("Checking Second Output Sample...");
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sequential Samples (0x11, 0x22)", test_num);
            reset_dut();


            @(posedge clk);
            in_valid = 1; in_data = 8'h11;
            @(posedge clk);
            in_valid = 0;


            while (!out_valid) @(posedge clk);
            #1; #1;
 check_outputs(8'h11, 1'b1);
            @(posedge clk);
            #1; #1;
 check_outputs(8'h11, 1'b1);


            @(posedge clk);
            in_valid = 1; in_data = 8'h22;
            @(posedge clk);
            in_valid = 0;


            while (!out_valid) @(posedge clk);
            #1; #1;
 check_outputs(8'h22, 1'b1);
            @(posedge clk);
            #1; #1;
 check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Boundary Values (0x00, 0xFF)", test_num);
            reset_dut();


            @(posedge clk);
            in_valid = 1; in_data = 8'hFF;
            @(posedge clk);
            in_valid = 0;
            while (!out_valid) @(posedge clk);
            repeat(2) begin
                #1; #1;
 check_outputs(8'hFF, 1'b1);
                @(posedge clk);
            end


            @(posedge clk);
            in_valid = 1; in_data = 8'h00;
            @(posedge clk);
            in_valid = 0;
            while (!out_valid) @(posedge clk);
            repeat(2) begin
                #1; #1;
 check_outputs(8'h00, 1'b1);
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();


            @(posedge clk);
            in_valid = 1; in_data = 8'h55;
            @(posedge clk);
            in_valid = 0;


            while (!out_valid) @(posedge clk);
            repeat(2) @(posedge clk);


            #1;
            $display("Checking for Idle (out_valid=0)...");
            #1;

            check_outputs(out_data, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset Recovery", test_num);
            reset_dut();

            @(posedge clk);
            in_valid = 1; in_data = 8'hAA;
            @(posedge clk);
            in_valid = 0;


            while (!out_valid) @(posedge clk);
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;


            #1;
            $display("Checking for Reset Quiet State...");
            #1;

            check_outputs(out_data, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_out_data;
        input expected_out_valid;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_valid=%b",
                         out_data, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_valid=%b",
                         expected_out_data, expected_out_valid);
                $display("  Got:      out_data=%h, out_valid=%b",
                         out_data, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, rst, out_data, out_valid);
    end

endmodule
